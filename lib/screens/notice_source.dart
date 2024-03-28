import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/notice.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/notice_del.dart';
import 'package:miel_work_web/screens/notice_mod.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_column_link.dart';
import 'package:path/path.dart' as p;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class NoticeSource extends DataGridSource {
  final BuildContext context;
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final List<NoticeModel> notices;

  NoticeSource({
    required this.context,
    required this.loginProvider,
    required this.homeProvider,
    required this.notices,
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
    cells.add(CustomColumnLabel(
      dateText('yyyy/MM/dd HH:mm', notice.createdAt),
    ));
    cells.add(CustomColumnLabel(notice.title));
    OrganizationGroupModel? noticeInGroup;
    if (homeProvider.groups.isNotEmpty) {
      for (OrganizationGroupModel group in homeProvider.groups) {
        if (group.id == notice.groupId) {
          noticeInGroup = group;
        }
      }
    }
    cells.add(CustomColumnLabel(noticeInGroup?.name ?? ''));
    if (notice.file != '') {
      File file = File(notice.file);
      cells.add(CustomColumnLink(
        label: '${notice.id}${notice.fileExt}',
        color: kBlueColor,
        onTap: () => downloadFile(
          url: notice.file,
          name: p.basename(file.path),
        ),
      ));
    } else {
      cells.add(const CustomColumnLabel(''));
    }
    cells.add(Row(
      children: [
        CustomButtonSm(
          labelText: '編集',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () => Navigator.push(
            context,
            FluentPageRoute(
              builder: (context) => NoticeModScreen(
                loginProvider: loginProvider,
                homeProvider: homeProvider,
                notice: notice,
                noticeInGroup: noticeInGroup,
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
              builder: (context) => NoticeDelScreen(
                loginProvider: loginProvider,
                homeProvider: homeProvider,
                notice: notice,
                noticeInGroup: noticeInGroup,
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
