import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/notice.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/notice_add.dart';
import 'package:miel_work_web/screens/notice_source.dart';
import 'package:miel_work_web/services/notice.dart';
import 'package:miel_work_web/widgets/animation_background.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_data_grid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class NoticeScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const NoticeScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  NoticeService noticeService = NoticeService();
  DateTime? searchStart;
  DateTime? searchEnd;

  @override
  Widget build(BuildContext context) {
    String organizationName = widget.loginProvider.organization?.name ?? '';
    OrganizationGroupModel? group = widget.homeProvider.currentGroup;
    String groupName = group?.name ?? '';
    String searchText = '指定なし';
    if (searchStart != null && searchEnd != null) {
      searchText =
          '${dateText('yyyy/MM/dd', searchStart)}～${dateText('yyyy/MM/dd', searchEnd)}';
    }
    return Stack(
      children: [
        const AnimationBackground(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '『$organizationName $groupName』のお知らせを表示しています。',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButtonSm(
                      icon: FluentIcons.calendar,
                      labelText: '期間検索: $searchText',
                      labelColor: kBlue600Color,
                      backgroundColor: kBlue100Color,
                      onPressed: () async {
                        var selected = await showDataRangePickerDialog(
                          context: context,
                          startValue: searchStart,
                          endValue: searchEnd,
                        );
                        if (selected != null &&
                            selected.first != null &&
                            selected.last != null) {
                          var diff = selected.last!.difference(selected.first!);
                          int diffDays = diff.inDays;
                          if (diffDays > 31) {
                            if (!mounted) return;
                            showMessage(context, '1ヵ月以上の範囲が選択されています', false);
                            return;
                          }
                          searchStart = selected.first;
                          searchEnd = selected.last;
                          setState(() {});
                        }
                      },
                    ),
                    CustomButtonSm(
                      icon: FluentIcons.add,
                      labelText: '新規追加',
                      labelColor: kWhiteColor,
                      backgroundColor: kBlueColor,
                      onPressed: () => Navigator.push(
                        context,
                        FluentPageRoute(
                          builder: (context) => NoticeAddScreen(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: noticeService.streamList(
                      organizationId: widget.loginProvider.organization?.id,
                      groupId: group?.id,
                      searchStart: searchStart,
                      searchEnd: searchEnd,
                    ),
                    builder: (context, snapshot) {
                      List<NoticeModel> notices = [];
                      if (snapshot.hasData) {
                        notices =
                            noticeService.generateList(data: snapshot.data);
                      }
                      return CustomDataGrid(
                        source: NoticeSource(
                          context: context,
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                          notices: notices,
                        ),
                        columns: [
                          GridColumn(
                            columnName: 'createdAt',
                            label: const CustomColumnLabel('追加日時'),
                          ),
                          GridColumn(
                            columnName: 'title',
                            label: const CustomColumnLabel('タイトル'),
                          ),
                          GridColumn(
                            columnName: 'groupId',
                            label: const CustomColumnLabel('送信先グループ'),
                          ),
                          GridColumn(
                            columnName: 'file',
                            label: const CustomColumnLabel('添付ファイル'),
                          ),
                          GridColumn(
                            columnName: 'edit',
                            label: const CustomColumnLabel('操作'),
                            width: 200,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
