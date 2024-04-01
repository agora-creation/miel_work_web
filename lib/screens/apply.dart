import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/apply.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/apply_add.dart';
import 'package:miel_work_web/screens/apply_source.dart';
import 'package:miel_work_web/services/apply.dart';
import 'package:miel_work_web/widgets/animation_background.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_data_grid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ApplyScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ApplyScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  ApplyService applyService = ApplyService();
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
                  '『$organizationName $groupName』の各種申請一覧を表示しています。',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                              var diff =
                                  selected.last!.difference(selected.first!);
                              int diffDays = diff.inDays;
                              if (diffDays > 31) {
                                if (!mounted) return;
                                showMessage(
                                    context, '1ヵ月以上の範囲が選択されています', false);
                                return;
                              }
                              searchStart = selected.first;
                              searchEnd = selected.last;
                              setState(() {});
                            }
                          },
                        ),
                        const SizedBox(width: 4),
                        CustomButtonSm(
                          icon: FluentIcons.search,
                          labelText: '承認状況: 承認待ち',
                          labelColor: kBlue600Color,
                          backgroundColor: kBlue100Color,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    CustomButtonSm(
                      icon: FluentIcons.add,
                      labelText: '新規申請',
                      labelColor: kWhiteColor,
                      backgroundColor: kBlueColor,
                      onPressed: () => Navigator.push(
                        context,
                        FluentPageRoute(
                          builder: (context) => ApplyAddScreen(
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
                    stream: applyService.streamList(
                      organizationId: widget.loginProvider.organization?.id,
                      approval: 0,
                      searchStart: searchStart,
                      searchEnd: searchEnd,
                    ),
                    builder: (context, snapshot) {
                      List<ApplyModel> applies = [];
                      if (snapshot.hasData) {
                        applies = applyService.generateList(
                          data: snapshot.data,
                          currentGroup: widget.homeProvider.currentGroup,
                        );
                      }
                      return CustomDataGrid(
                        source: ApplySource(
                          context: context,
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                          applies: applies,
                        ),
                        columns: [
                          GridColumn(
                            columnName: 'createdAt',
                            label: const CustomColumnLabel('申請日時'),
                          ),
                          GridColumn(
                            columnName: 'createdUserName',
                            label: const CustomColumnLabel('申請者名'),
                          ),
                          GridColumn(
                            columnName: 'type',
                            label: const CustomColumnLabel('申請種別'),
                          ),
                          GridColumn(
                            columnName: 'title',
                            label: const CustomColumnLabel('件名'),
                          ),
                          GridColumn(
                            columnName: 'price',
                            label: const CustomColumnLabel('金額'),
                          ),
                          GridColumn(
                            columnName: 'approval',
                            label: const CustomColumnLabel('承認状況'),
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
