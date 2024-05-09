import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/apply.dart';
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
  String? searchType;
  int searchApproval = 0;

  @override
  Widget build(BuildContext context) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        InfoLabel(
                          label: '期間検索',
                          child: Button(
                            child: Text(searchText),
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
                        ),
                        const SizedBox(width: 4),
                        InfoLabel(
                          label: '申請種別',
                          child: ComboBox<String?>(
                            value: searchType,
                            items: kApplyTypes.map((e) {
                              return ComboBoxItem(
                                value: e,
                                child: Text('$e申請'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                searchType = value;
                              });
                            },
                            placeholder: const Text(
                              '指定なし',
                              style: TextStyle(color: kGreyColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        InfoLabel(
                          label: '承認状況',
                          child: ComboBox<int>(
                            value: searchApproval,
                            items: const [
                              ComboBoxItem(
                                value: 0,
                                child: Text('承認待ち'),
                              ),
                              ComboBoxItem(
                                value: 1,
                                child: Text('承認済み'),
                              ),
                              ComboBoxItem(
                                value: 9,
                                child: Text('否決'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                searchApproval = value ?? 0;
                              });
                            },
                          ),
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
                      searchType: searchType,
                      searchApproval: searchApproval,
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
                            columnName: 'number',
                            label: const CustomColumnLabel('申請番号'),
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
