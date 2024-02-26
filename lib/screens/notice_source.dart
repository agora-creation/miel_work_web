import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/notice.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/notice.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class NoticeSource extends DataGridSource {
  final BuildContext context;
  final List<NoticeModel> notices;
  final List<OrganizationGroupModel> groups;

  NoticeSource({
    required this.context,
    required this.notices,
    required this.groups,
  }) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = notices.map<DataGridRow>((notice) {
      return DataGridRow(cells: [
        DataGridCell(
          columnName: 'id',
          value: notice.id,
        ),
        DataGridCell(
          columnName: 'title',
          value: notice.title,
        ),
        DataGridCell(
          columnName: 'content',
          value: notice.content,
        ),
        DataGridCell(
          columnName: 'groupId',
          value: notice.groupId,
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
    NoticeModel notice = notices.singleWhere(
      (e) => e.id == '${row.getCells()[0].value}',
    );
    cells.add(CustomColumnLabel('${row.getCells()[1].value}'));
    cells.add(CustomColumnLabel('${row.getCells()[2].value}'));
    OrganizationGroupModel? currentGroup;
    if (groups.isNotEmpty) {
      for (OrganizationGroupModel group in groups) {
        if (group.id == notice.groupId) {
          currentGroup = group;
        }
      }
    }
    cells.add(CustomColumnLabel(currentGroup?.name ?? ''));
    cells.add(Row(
      children: [
        CustomButtonSm(
          labelText: '削除',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => DelNoticeDialog(
              notice: notice,
              currentGroup: currentGroup,
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

class DelNoticeDialog extends StatefulWidget {
  final NoticeModel notice;
  final OrganizationGroupModel? currentGroup;

  const DelNoticeDialog({
    required this.notice,
    required this.currentGroup,
    super.key,
  });

  @override
  State<DelNoticeDialog> createState() => _DelNoticeDialogState();
}

class _DelNoticeDialogState extends State<DelNoticeDialog> {
  @override
  Widget build(BuildContext context) {
    final noticeProvider = Provider.of<NoticeProvider>(context);
    return ContentDialog(
      title: const Text(
        'お知らせを削除する',
        style: TextStyle(fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Text('本当に削除しますか？')),
            const SizedBox(height: 8),
            InfoLabel(
              label: 'タイトル',
              child: Text(widget.notice.title),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: 'お知らせ内容',
              child: Text(widget.notice.content),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: 'ファイル',
              child: Text(widget.notice.file),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '送信先グループ',
              child: Text(widget.currentGroup?.name ?? ''),
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
          labelText: '削除する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await noticeProvider.delete(
              notice: widget.notice,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, 'お知らせを削除しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
