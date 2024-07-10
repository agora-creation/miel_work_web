import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/problem.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/problem_del.dart';
import 'package:miel_work_web/screens/problem_mod.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ProblemSource extends DataGridSource {
  final BuildContext context;
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final List<ProblemModel> problems;

  ProblemSource({
    required this.context,
    required this.loginProvider,
    required this.homeProvider,
    required this.problems,
  }) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = problems.map<DataGridRow>((problem) {
      return DataGridRow(cells: [
        DataGridCell(
          columnName: 'id',
          value: problem.id,
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
    ProblemModel problem = problems.singleWhere(
      (e) => e.id == '${row.getCells()[0].value}',
    );
    cells.add(CustomColumnLabel(
      dateText('yyyy/MM/dd HH:mm', problem.createdAt),
    ));
    cells.add(CustomColumnLabel(problem.type));
    cells.add(CustomColumnLabel(problem.picName));
    cells.add(CustomColumnLabel(problem.targetName));
    String stateText = '';
    if (problem.states.isNotEmpty) {
      for (String state in problem.states) {
        if (stateText != '') stateText += '／';
        stateText += state;
      }
    }
    cells.add(CustomColumnLabel(stateText));
    cells.add(Row(
      children: [
        CustomButtonSm(
          labelText: '編集',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () => Navigator.push(
            context,
            FluentPageRoute(
              builder: (context) => ProblemModScreen(
                loginProvider: loginProvider,
                homeProvider: homeProvider,
                problem: problem,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        CustomButtonSm(
          labelText: '削除',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () => Navigator.push(
            context,
            FluentPageRoute(
              builder: (context) => ProblemDelScreen(
                loginProvider: loginProvider,
                homeProvider: homeProvider,
                problem: problem,
              ),
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
