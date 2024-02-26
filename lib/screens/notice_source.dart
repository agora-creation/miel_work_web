import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/notice.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/notice.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
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
          labelText: '編集',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => ModNoticeDialog(
              notice: notice,
              currentGroup: currentGroup,
            ),
          ),
        ),
        const SizedBox(width: 4),
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

class ModNoticeDialog extends StatefulWidget {
  final NoticeModel notice;
  final OrganizationGroupModel? currentGroup;

  const ModNoticeDialog({
    required this.notice,
    required this.currentGroup,
    super.key,
  });

  @override
  State<ModNoticeDialog> createState() => _ModNoticeDialogState();
}

class _ModNoticeDialogState extends State<ModNoticeDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  PlatformFile? pickedFile;
  OrganizationGroupModel? selectedGroup;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.notice.title;
    contentController.text = widget.notice.content;
    selectedGroup = widget.currentGroup;
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final noticeProvider = Provider.of<NoticeProvider>(context);
    List<ComboBoxItem<OrganizationGroupModel>> groupItems = [];
    if (homeProvider.groups.isNotEmpty) {
      groupItems.add(const ComboBoxItem(
        value: null,
        child: Text('グループ未選択'),
      ));
      for (OrganizationGroupModel group in homeProvider.groups) {
        groupItems.add(ComboBoxItem(
          value: group,
          child: Text(group.name),
        ));
      }
    }
    return ContentDialog(
      title: const Text(
        'お知らせを編集する',
        style: TextStyle(fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoLabel(
              label: 'タイトル',
              child: CustomTextBox(
                controller: titleController,
                placeholder: '例) 休館日について',
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: 'お知らせ内容',
              child: CustomTextBox(
                controller: contentController,
                placeholder: '',
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
            const SizedBox(height: 8),
            CustomButtonSm(
              labelText: 'ファイル選択',
              labelColor: kWhiteColor,
              backgroundColor: kGreyColor,
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf'],
                );
                if (result == null) return;
                setState(() {
                  pickedFile = result.files.first;
                });
              },
            ),
            pickedFile != null
                ? Text('${pickedFile?.name}')
                : Text('${widget.notice.id}.pdf'),
            const SizedBox(height: 8),
            InfoLabel(
              label: '送信先グループ',
              child: ComboBox<OrganizationGroupModel>(
                isExpanded: true,
                value: selectedGroup,
                items: groupItems,
                onChanged: (value) {
                  setState(() {
                    selectedGroup = value;
                  });
                },
                placeholder: const Text('グループ未選択'),
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
          labelText: '入力内容を保存',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await noticeProvider.update(
              notice: widget.notice,
              title: titleController.text,
              content: contentController.text,
              pickedFile: pickedFile,
              group: selectedGroup,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, 'お知らせを編集しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
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
