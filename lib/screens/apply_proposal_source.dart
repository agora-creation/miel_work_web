import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/apply_proposal.dart';
import 'package:miel_work_web/providers/apply_proposal.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:provider/provider.dart';
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
          value: '¥${proposal.price}',
        ),
        DataGridCell(
          columnName: 'approval',
          value: proposal.approval ? '承認済み' : '承認待ち',
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
    cells.add(Row(
      children: [
        proposal.createdUserId != loginProvider.user?.id && !proposal.approval
            ? CustomButtonSm(
                labelText: '承認',
                labelColor: kWhiteColor,
                backgroundColor: kRedColor,
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => ApprovalApplyProposalDialog(
                    loginProvider: loginProvider,
                    homeProvider: homeProvider,
                    proposal: proposal,
                  ),
                ),
              )
            : const CustomButtonSm(
                labelText: '承認',
                labelColor: kWhiteColor,
                backgroundColor: kGreyColor,
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

class ApprovalApplyProposalDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyProposalModel proposal;

  const ApprovalApplyProposalDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.proposal,
    super.key,
  });

  @override
  State<ApprovalApplyProposalDialog> createState() =>
      _ApprovalApplyProposalDialogState();
}

class _ApprovalApplyProposalDialogState
    extends State<ApprovalApplyProposalDialog> {
  @override
  Widget build(BuildContext context) {
    final proposalProvider = Provider.of<ApplyProposalProvider>(context);
    return ContentDialog(
      title: const Text(
        '稟議申請を承認',
        style: TextStyle(fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoLabel(
              label: '件名',
              child: CustomTextBox(
                controller: TextEditingController(
                  text: widget.proposal.title,
                ),
                enabled: false,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '内容',
              child: CustomTextBox(
                controller: TextEditingController(
                  text: widget.proposal.content,
                ),
                keyboardType: TextInputType.multiline,
                enabled: false,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '金額',
              child: CustomTextBox(
                controller: TextEditingController(
                  text: '${widget.proposal.price}',
                ),
                enabled: false,
              ),
            ),
          ],
        ),
      ),
      actions: [
        CustomButtonSm(
          labelText: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButtonSm(
          labelText: '承認する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await proposalProvider.update(
              proposal: widget.proposal,
              approval: true,
              loginUser: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '承認しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
