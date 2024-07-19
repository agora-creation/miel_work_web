import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/apply.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/apply_history_detail.dart';
import 'package:miel_work_web/services/pdf.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:page_transition/page_transition.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ApplyHistorySource extends DataGridSource {
  final BuildContext context;
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final List<ApplyModel> applies;

  ApplyHistorySource({
    required this.context,
    required this.loginProvider,
    required this.homeProvider,
    required this.applies,
  }) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = applies.map<DataGridRow>((apply) {
      return DataGridRow(cells: [
        DataGridCell(
          columnName: 'id',
          value: apply.id,
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
    ApplyModel apply = applies.singleWhere(
      (e) => e.id == '${row.getCells()[0].value}',
    );
    String approvedAtText = dateText('yyyy/MM/dd HH:mm', apply.approvedAt);
    cells.add(CustomColumnLabel(approvedAtText));
    cells.add(CustomColumnLabel(apply.approvalNumber));
    String createdAtText = dateText('yyyy/MM/dd HH:mm', apply.createdAt);
    cells.add(CustomColumnLabel(createdAtText));
    cells.add(CustomColumnLabel(apply.number));
    cells.add(Align(
      alignment: Alignment.centerLeft,
      child: Chip(
        label: Text('${apply.type}申請'),
        backgroundColor: apply.typeColor(),
      ),
    ));
    cells.add(CustomColumnLabel(apply.title));
    cells.add(CustomColumnLabel(apply.createdUserName));
    cells.add(CustomColumnLabel(apply.approvalText()));
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
                child: ApplyHistoryDetailScreen(
                  loginProvider: loginProvider,
                  homeProvider: homeProvider,
                  apply: apply,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 4),
        CustomButton(
          type: ButtonSizeType.sm,
          label: 'PDF印刷',
          labelColor: kBlackColor,
          backgroundColor: kRed200Color,
          onPressed: () async => await PdfService().applyDownload(apply),
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
