import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/stock.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/stock.dart';
import 'package:miel_work_web/providers/stock_history.dart';
import 'package:miel_work_web/screens/stock_history.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class StockSource extends DataGridSource {
  final BuildContext context;
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final List<StockModel> stocks;

  StockSource({
    required this.context,
    required this.loginProvider,
    required this.homeProvider,
    required this.stocks,
  }) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = stocks.map<DataGridRow>((stock) {
      return DataGridRow(cells: [
        DataGridCell(
          columnName: 'id',
          value: stock.id,
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
    StockModel stock = stocks.singleWhere(
      (e) => e.id == '${row.getCells()[0].value}',
    );
    cells.add(CustomColumnLabel(stock.number));
    cells.add(CustomColumnLabel(stock.name));
    cells.add(Row(
      children: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: '(ー)出庫',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AddStockType0Dialog(
              loginProvider: loginProvider,
              homeProvider: homeProvider,
              stock: stock,
            ),
          ),
          disabled: stock.quantity == 0,
        ),
        const SizedBox(width: 4),
        CustomColumnLabel(stock.quantity.toString()),
        const SizedBox(width: 4),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '(＋)入庫',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AddStockType1Dialog(
              loginProvider: loginProvider,
              homeProvider: homeProvider,
              stock: stock,
            ),
          ),
        ),
        const SizedBox(width: 4),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '在庫変動履歴',
          labelColor: kBlackColor,
          backgroundColor: kGreyColor,
          onPressed: () => showBottomUpScreen(
            context,
            StockHistoryScreen(
              loginProvider: loginProvider,
              homeProvider: homeProvider,
              stock: stock,
            ),
          ),
        ),
      ],
    ));
    cells.add(Row(
      children: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: '編集',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => ModStockDialog(
              loginProvider: loginProvider,
              homeProvider: homeProvider,
              stock: stock,
            ),
          ),
        ),
        const SizedBox(width: 4),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '削除',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => DelStockDialog(
              loginProvider: loginProvider,
              homeProvider: homeProvider,
              stock: stock,
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

class AddStockType0Dialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final StockModel stock;

  const AddStockType0Dialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.stock,
    super.key,
  });

  @override
  State<AddStockType0Dialog> createState() => _AddStockType0DialogState();
}

class _AddStockType0DialogState extends State<AddStockType0Dialog> {
  TextEditingController quantityController = TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    final stockHistoryProvider = Provider.of<StockHistoryProvider>(context);
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FormLabel(
            '在庫品名',
            child: FormValue(widget.stock.name),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '出庫する数',
            child: CustomTextField(
              controller: quantityController,
              textInputType: TextInputType.number,
              maxLines: 1,
            ),
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
          label: '出庫する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await stockHistoryProvider.create(
              stock: widget.stock,
              type: 0,
              quantity: int.parse(quantityController.text),
              loginUser: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '在庫変動履歴が追加されました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class AddStockType1Dialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final StockModel stock;

  const AddStockType1Dialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.stock,
    super.key,
  });

  @override
  State<AddStockType1Dialog> createState() => _AddStockType1DialogState();
}

class _AddStockType1DialogState extends State<AddStockType1Dialog> {
  TextEditingController quantityController = TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    final stockHistoryProvider = Provider.of<StockHistoryProvider>(context);
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FormLabel(
            '在庫品名',
            child: FormValue(widget.stock.name),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '入庫する数',
            child: CustomTextField(
              controller: quantityController,
              textInputType: TextInputType.number,
              maxLines: 1,
            ),
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
          label: '入庫する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await stockHistoryProvider.create(
              stock: widget.stock,
              type: 1,
              quantity: int.parse(quantityController.text),
              loginUser: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '在庫変動履歴が追加されました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ModStockDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final StockModel stock;

  const ModStockDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.stock,
    super.key,
  });

  @override
  State<ModStockDialog> createState() => _ModStockDialogState();
}

class _ModStockDialogState extends State<ModStockDialog> {
  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    numberController.text = widget.stock.number;
    nameController.text = widget.stock.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FormLabel(
            '在庫No',
            child: CustomTextField(
              controller: numberController,
              textInputType: TextInputType.number,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '在庫品名',
            child: CustomTextField(
              controller: nameController,
              textInputType: TextInputType.text,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '現在の在庫数',
            child: FormValue(widget.stock.quantity.toString()),
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
          label: '保存する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await stockProvider.update(
              organization: widget.loginProvider.organization,
              stock: widget.stock,
              number: numberController.text,
              name: nameController.text,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '在庫品情報が変更されました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class DelStockDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final StockModel stock;

  const DelStockDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.stock,
    super.key,
  });

  @override
  State<DelStockDialog> createState() => _DelStockDialogState();
}

class _DelStockDialogState extends State<DelStockDialog> {
  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          const Text(
            '本当に削除しますか？',
            style: TextStyle(color: kRedColor),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '在庫No',
            child: FormValue(widget.stock.number),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '在庫品名',
            child: FormValue(widget.stock.name),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '現在の在庫数',
            child: FormValue(widget.stock.quantity.toString()),
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
            String? error = await stockProvider.delete(
              stock: widget.stock,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '在庫品を削除しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
