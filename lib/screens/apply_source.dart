import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/apply.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/apply_detail.dart';
import 'package:miel_work_web/services/pdf.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ApplySource extends DataGridSource {
  final BuildContext context;
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final List<ApplyModel> applies;

  ApplySource({
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
    String createdAtText = dateText('yyyy/MM/dd HH:mm', apply.createdAt);
    cells.add(CustomColumnLabel(createdAtText));
    cells.add(CustomColumnLabel(apply.createdUserName));
    cells.add(CustomColumnLabel(apply.number));
    cells.add(CustomColumnLabel('${apply.type}申請'));
    cells.add(CustomColumnLabel(apply.title));
    if (apply.type == '稟議' || apply.type == '支払伺い') {
      cells.add(CustomColumnLabel('¥ ${apply.formatPrice()}'));
    } else {
      cells.add(const CustomColumnLabel(''));
    }
    cells.add(CustomColumnLabel(apply.approvalText()));
    cells.add(Row(
      children: [
        CustomButtonSm(
          labelText: '詳細',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () => Navigator.push(
            context,
            FluentPageRoute(
              builder: (context) => ApplyDetailScreen(
                loginProvider: loginProvider,
                homeProvider: homeProvider,
                apply: apply,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        CustomButtonSm(
          labelText: 'PDF印刷',
          labelColor: kBlackColor,
          backgroundColor: kRed200Color,
          onPressed: () async {
            await PdfService().applyDownload(apply);
          },
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
