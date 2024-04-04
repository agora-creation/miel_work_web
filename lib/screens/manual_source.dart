import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/manual.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/manual.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_column_link.dart';
import 'package:miel_work_web/widgets/custom_pdf_field.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ManualSource extends DataGridSource {
  final BuildContext context;
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final List<ManualModel> manuals;

  ManualSource({
    required this.context,
    required this.loginProvider,
    required this.homeProvider,
    required this.manuals,
  }) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = manuals.map<DataGridRow>((manual) {
      return DataGridRow(cells: [
        DataGridCell(
          columnName: 'id',
          value: manual.id,
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
    ManualModel manual = manuals.singleWhere(
      (e) => e.id == '${row.getCells()[0].value}',
    );
    cells.add(CustomColumnLabel(
      dateText('yyyy/MM/dd HH:mm', manual.createdAt),
    ));
    cells.add(CustomColumnLabel(manual.title));
    File file = File(manual.file);
    cells.add(CustomColumnLink(
      label: '${manual.id}.pdf',
      color: kBlueColor,
      onTap: () => downloadFile(
        url: manual.file,
        name: p.basename(file.path),
      ),
    ));
    OrganizationGroupModel? manualInGroup;
    if (homeProvider.groups.isNotEmpty) {
      for (OrganizationGroupModel group in homeProvider.groups) {
        if (group.id == manual.groupId) {
          manualInGroup = group;
        }
      }
    }
    if (manualInGroup != null) {
      cells.add(CustomColumnLabel(manualInGroup.name));
    } else {
      cells.add(const CustomColumnLabel(
        'グループの指定なし',
        labelColor: kGreyColor,
      ));
    }
    cells.add(Row(
      children: [
        CustomButtonSm(
          labelText: '編集',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => ModManualDialog(
              loginProvider: loginProvider,
              homeProvider: homeProvider,
              manual: manual,
              manualInGroup: manualInGroup,
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
            builder: (context) => DelManualDialog(
              loginProvider: loginProvider,
              homeProvider: homeProvider,
              manual: manual,
              manualInGroup: manualInGroup,
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

class ModManualDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ManualModel manual;
  final OrganizationGroupModel? manualInGroup;

  const ModManualDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.manual,
    required this.manualInGroup,
    super.key,
  });

  @override
  State<ModManualDialog> createState() => _ModManualDialogState();
}

class _ModManualDialogState extends State<ModManualDialog> {
  TextEditingController titleController = TextEditingController();
  PlatformFile? pickedFile;
  OrganizationGroupModel? selectedGroup;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.manual.title;
    selectedGroup = widget.manualInGroup;
  }

  @override
  Widget build(BuildContext context) {
    final manualProvider = Provider.of<ManualProvider>(context);
    List<ComboBoxItem<OrganizationGroupModel>> groupItems = [];
    if (widget.homeProvider.groups.isNotEmpty) {
      groupItems.add(const ComboBoxItem(
        value: null,
        child: Text(
          'グループの指定なし',
          style: TextStyle(color: kGreyColor),
        ),
      ));
      for (OrganizationGroupModel group in widget.homeProvider.groups) {
        groupItems.add(ComboBoxItem(
          value: group,
          child: Text(group.name),
        ));
      }
    }
    return ContentDialog(
      title: const Text(
        '業務マニュアルを編集',
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
                placeholder: '例) 掃除について',
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            CustomPdfField(
              value: pickedFile,
              defaultValue: '${widget.manual.id}.pdf',
              onTap: () async {
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
            const SizedBox(height: 8),
            InfoLabel(
              label: '公開グループ',
              child: ComboBox<OrganizationGroupModel>(
                isExpanded: true,
                value: selectedGroup,
                items: groupItems,
                onChanged: (value) {
                  setState(() {
                    selectedGroup = value;
                  });
                },
                placeholder: const Text(
                  'グループの指定なし',
                  style: TextStyle(color: kGreyColor),
                ),
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
            String? error = await manualProvider.update(
              organization: widget.loginProvider.organization,
              manual: widget.manual,
              title: titleController.text,
              pickedFile: pickedFile,
              group: selectedGroup,
              loginUser: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '業務マニュアルを編集しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class DelManualDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ManualModel manual;
  final OrganizationGroupModel? manualInGroup;

  const DelManualDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.manual,
    required this.manualInGroup,
    super.key,
  });

  @override
  State<DelManualDialog> createState() => _DelManualDialogState();
}

class _DelManualDialogState extends State<DelManualDialog> {
  @override
  Widget build(BuildContext context) {
    final manualProvider = Provider.of<ManualProvider>(context);
    return ContentDialog(
      title: const Text(
        '業務マニュアルを削除',
        style: TextStyle(fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '本当に削除しますか？',
              style: TextStyle(color: kRedColor),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: 'タイトル',
              child: Container(
                color: kGrey200Color,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text(widget.manual.title),
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: 'PDFファイル',
              child: Container(
                color: kGrey200Color,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text('${widget.manual.id}.pdf'),
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '公開グループ',
              child: Container(
                color: kGrey200Color,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text(widget.manualInGroup?.name ?? 'グループの指定なし'),
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
          labelText: '削除する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await manualProvider.delete(
              manual: widget.manual,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '業務マニュアルを削除しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
