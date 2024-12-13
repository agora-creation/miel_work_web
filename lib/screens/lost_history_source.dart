import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/lost.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_column_link.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LostHistorySource extends DataGridSource {
  final BuildContext context;
  final List<LostModel> losts;

  LostHistorySource({
    required this.context,
    required this.losts,
  }) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = losts.map<DataGridRow>((lost) {
      return DataGridRow(cells: [
        DataGridCell(
          columnName: 'id',
          value: lost.id,
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
    LostModel lost = losts.singleWhere(
      (e) => e.id == '${row.getCells()[0].value}',
    );
    cells.add(CustomColumnLabel(
      dateText('yyyy/MM/dd', lost.returnAt),
    ));
    cells.add(CustomColumnLabel(lost.returnUser));
    cells.add(CustomColumnLink(
      label: '署名を確認',
      color: kBlueColor,
      onTap: () => showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          content: SizedBox(
            width: 600,
            child: Image.network(
              lost.signImage,
              fit: BoxFit.cover,
            ),
          ),
          actions: [
            CustomButton(
              type: ButtonSizeType.sm,
              label: '閉じる',
              labelColor: kWhiteColor,
              backgroundColor: kGreyColor,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    ));
    cells.add(CustomColumnLabel(lost.itemNumber));
    cells.add(CustomColumnLabel(lost.itemName));
    cells.add(CustomColumnLabel(
      dateText('yyyy/MM/dd', lost.discoveryAt),
    ));
    cells.add(CustomColumnLabel(lost.discoveryPlace));
    cells.add(CustomColumnLabel(lost.discoveryUser));
    cells.add(CustomColumnLabel(lost.remarks));
    cells.add(CustomColumnLabel(lost.statusText()));
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
