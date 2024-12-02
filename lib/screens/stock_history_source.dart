import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/stock.dart';
import 'package:miel_work_web/models/stock_history.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/stock_history.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class StockHistorySource extends DataGridSource {
  final BuildContext context;
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final StockModel stock;
  final List<StockHistoryModel> stockHistories;

  StockHistorySource({
    required this.context,
    required this.loginProvider,
    required this.homeProvider,
    required this.stock,
    required this.stockHistories,
  }) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = stockHistories.map<DataGridRow>((stockHistory) {
      return DataGridRow(cells: [
        DataGridCell(
          columnName: 'id',
          value: stockHistory.id,
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
    StockHistoryModel stockHistory = stockHistories.singleWhere(
      (e) => e.id == '${row.getCells()[0].value}',
    );
    String createdAtText = dateText('yyyy/MM/dd HH:mm', stockHistory.createdAt);
    cells.add(CustomColumnLabel(createdAtText));
    cells.add(Align(
      alignment: Alignment.centerLeft,
      child: Chip(
        label: Text(stockHistory.typeText()),
        backgroundColor: stockHistory.typeColor(),
      ),
    ));
    String sign = '';
    switch (stockHistory.type) {
      case 0:
        sign = 'ー';
        break;
      case 1:
        sign = '＋';
        break;
      default:
        break;
    }
    cells.add(CustomColumnLabel('$sign${stockHistory.quantity}'));
    cells.add(CustomColumnLabel(stockHistory.createdUserName));
    cells.add(Row(
      children: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: '削除',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => DelStockHistoryDialog(
              loginProvider: loginProvider,
              homeProvider: homeProvider,
              stock: stock,
              stockHistory: stockHistory,
            ),
          ),
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

class DelStockHistoryDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final StockModel stock;
  final StockHistoryModel stockHistory;

  const DelStockHistoryDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.stock,
    required this.stockHistory,
    super.key,
  });

  @override
  State<DelStockHistoryDialog> createState() => _DelStockHistoryDialogState();
}

class _DelStockHistoryDialogState extends State<DelStockHistoryDialog> {
  @override
  Widget build(BuildContext context) {
    final stockHistoryProvider = Provider.of<StockHistoryProvider>(context);
    return CustomAlertDialog(
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8),
          Text(
            '本当に削除しますか？',
            style: TextStyle(color: kRedColor),
          ),
          Text(
            '※在庫数は元に戻ります。',
            style: TextStyle(color: kRedColor),
          ),
        ],
      ),
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '削除する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await stockHistoryProvider.delete(
              stock: widget.stock,
              stockHistory: widget.stockHistory,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '在庫変動履歴を削除しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
