import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/request_facility.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/request_facility_detail.dart';
import 'package:miel_work_web/services/pdf.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:page_transition/page_transition.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RequestFacilityHistorySource extends DataGridSource {
  final BuildContext context;
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final List<RequestFacilityModel> facilities;

  RequestFacilityHistorySource({
    required this.context,
    required this.loginProvider,
    required this.homeProvider,
    required this.facilities,
  }) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = facilities.map<DataGridRow>((facility) {
      return DataGridRow(cells: [
        DataGridCell(
          columnName: 'id',
          value: facility.id,
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
    RequestFacilityModel facility = facilities.singleWhere(
      (e) => e.id == '${row.getCells()[0].value}',
    );
    String approvedAtText = dateText('yyyy/MM/dd HH:mm', facility.approvedAt);
    cells.add(CustomColumnLabel(approvedAtText));
    String createdAtText = dateText('yyyy/MM/dd HH:mm', facility.createdAt);
    cells.add(CustomColumnLabel(createdAtText));
    cells.add(CustomColumnLabel(facility.companyName));
    cells.add(CustomColumnLabel(facility.companyUserName));
    cells.add(CustomColumnLabel(facility.companyUserEmail));
    cells.add(CustomColumnLabel(facility.companyUserTel));
    cells.add(CustomColumnLabel(facility.approvalText()));
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
                child: RequestFacilityDetailScreen(
                  loginProvider: loginProvider,
                  homeProvider: homeProvider,
                  facility: facility,
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
              await PdfService().requestFacilityDownload(facility),
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
