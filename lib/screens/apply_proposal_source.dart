import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/apply_proposal.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/apply_proposal_detail.dart';
import 'package:miel_work_web/services/pdf.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ApplyProposalSource extends DataGridSource {
  final BuildContext context;
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final List<ApplyProposalModel> proposals;

  ApplyProposalSource({
    required this.context,
    required this.loginProvider,
    required this.homeProvider,
    required this.proposals,
  }) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = proposals.map<DataGridRow>((proposal) {
      return DataGridRow(cells: [
        DataGridCell(
          columnName: 'id',
          value: proposal.id,
        ),
        DataGridCell(
          columnName: 'createdAt',
          value: dateText('yyyy/MM/dd HH:mm', proposal.createdAt),
        ),
        DataGridCell(
          columnName: 'createdUserName',
          value: proposal.createdUserName,
        ),
        DataGridCell(
          columnName: 'title',
          value: proposal.title,
        ),
        DataGridCell(
          columnName: 'price',
          value: '¥ ${proposal.formatPrice()}',
        ),
        DataGridCell(
          columnName: 'approval',
          value: proposal.approval ? '承認済み' : '承認待ち',
        ),
        DataGridCell(
          columnName: 'approvedAt',
          value: proposal.approval
              ? dateText('yyyy/MM/dd HH:mm', proposal.createdAt)
              : '',
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
    ApplyProposalModel proposal = proposals.singleWhere(
      (e) => e.id == '${row.getCells()[0].value}',
    );
    cells.add(CustomColumnLabel('${row.getCells()[1].value}'));
    cells.add(CustomColumnLabel('${row.getCells()[2].value}'));
    cells.add(CustomColumnLabel('${row.getCells()[3].value}'));
    cells.add(CustomColumnLabel('${row.getCells()[4].value}'));
    cells.add(CustomColumnLabel('${row.getCells()[5].value}'));
    cells.add(CustomColumnLabel('${row.getCells()[6].value}'));
    cells.add(Row(
      children: [
        CustomButtonSm(
          labelText: '詳細',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () => Navigator.push(
            context,
            FluentPageRoute(
              builder: (context) => ApplyProposalDetailScreen(
                loginProvider: loginProvider,
                homeProvider: homeProvider,
                proposal: proposal,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        CustomButtonSm(
          labelText: 'PDF印刷',
          labelColor: kBlackColor,
          backgroundColor: kRed200Color,
          onPressed: () async =>
              await PdfService().applyProposalDownload(proposal),
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
