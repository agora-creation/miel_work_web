import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/manual.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/manual.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_column_link.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ManualSource extends DataGridSource {
  final BuildContext context;
  final List<ManualModel> manuals;
  final List<OrganizationGroupModel> groups;

  ManualSource({
    required this.context,
    required this.manuals,
    required this.groups,
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
        DataGridCell(
          columnName: 'title',
          value: manual.title,
        ),
        DataGridCell(
          columnName: 'file',
          value: manual.file,
        ),
        DataGridCell(
          columnName: 'groupId',
          value: manual.groupId,
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
    cells.add(CustomColumnLabel('${row.getCells()[1].value}'));
    File file = File('${row.getCells()[2].value}');
    cells.add(CustomColumnLink(
      label: '${row.getCells()[0].value}.pdf',
      color: kBlueColor,
      onTap: () {},
    ));
    OrganizationGroupModel? currentGroup;
    if (groups.isNotEmpty) {
      for (OrganizationGroupModel group in groups) {
        if (group.id == manual.groupId) {
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
            builder: (context) => DelManualDialog(
              manual: manual,
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

class DelManualDialog extends StatefulWidget {
  final ManualModel manual;
  final OrganizationGroupModel? currentGroup;

  const DelManualDialog({
    required this.manual,
    required this.currentGroup,
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
        '業務マニュアルを削除する',
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
              child: Text(widget.manual.title),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: 'PDFファイル',
              child: Text('${widget.manual.id}.pdf'),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '公開グループ',
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
