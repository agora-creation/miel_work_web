import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/request_overtime.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/request_overtime_history_detail.dart';
import 'package:miel_work_web/services/pdf.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:page_transition/page_transition.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RequestOvertimeHistorySource extends DataGridSource {
  final BuildContext context;
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final List<RequestOvertimeModel> overtimes;

  RequestOvertimeHistorySource({
    required this.context,
    required this.loginProvider,
    required this.homeProvider,
    required this.overtimes,
  }) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = overtimes.map<DataGridRow>((overtime) {
      return DataGridRow(cells: [
        DataGridCell(
          columnName: 'id',
          value: overtime.id,
        ),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int rowIndex = dataGridRows.indexOf(row);
    Color backgroundColor = Colors.transparent;
    if ((rowIndex % 2) == 0) {
      backgroundColor = kWhiteColor;
    }
    List<Widget> cells = [];
    RequestOvertimeModel overtime = overtimes.singleWhere(
      (e) => e.id == '${row.getCells()[0].value}',
    );
    String approvedAtText = dateText('yyyy/MM/dd HH:mm', overtime.approvedAt);
    cells.add(CustomColumnLabel(approvedAtText));
    String createdAtText = dateText('yyyy/MM/dd HH:mm', overtime.createdAt);
    cells.add(CustomColumnLabel(createdAtText));
    cells.add(CustomColumnLabel(overtime.companyName));
    cells.add(CustomColumnLabel(overtime.companyUserName));
    cells.add(CustomColumnLabel(overtime.companyUserEmail));
    cells.add(CustomColumnLabel(overtime.companyUserTel));
    cells.add(CustomColumnLabel(overtime.approvalText()));
    cells.add(Row(
      children: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: '詳細',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: RequestOvertimeHistoryDetailScreen(
                  loginProvider: loginProvider,
                  homeProvider: homeProvider,
                  overtime: overtime,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 4),
        CustomButton(
          type: ButtonSizeType.sm,
          label: 'PDF出力',
          labelColor: kWhiteColor,
          backgroundColor: kPdfColor,
          onPressed: () async =>
              await PdfService().requestOvertimeDownload(overtime),
        ),
      ],
    ));
    return DataGridRowAdapter(color: backgroundColor, cells: cells);
  }

  @override
  Future<void> handleLoadMoreRows() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    buildDataGridRows();
    notifyListeners();
  }

  @override
  Future<void> handleRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    buildDataGridRows();
    notifyListeners();
  }

  @override
  Widget? buildTableSummaryCellWidget(
    GridTableSummaryRow summaryRow,
    GridSummaryColumn? summaryColumn,
    RowColumnIndex rowColumnIndex,
    String summaryValue,
  ) {
    Widget? widget;
    Widget buildCell(
      String value,
      EdgeInsets padding,
      Alignment alignment,
    ) {
      return Container(
        padding: padding,
        alignment: alignment,
        child: Text(value, softWrap: false),
      );
    }

    widget = buildCell(
      summaryValue,
      const EdgeInsets.all(4),
      Alignment.centerLeft,
    );
    return widget;
  }

  void updateDataSource() {
    notifyListeners();
  }
}
