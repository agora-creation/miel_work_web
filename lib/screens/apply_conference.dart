import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/apply_conference.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/apply_conference_add.dart';
import 'package:miel_work_web/screens/apply_conference_source.dart';
import 'package:miel_work_web/services/apply_conference.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_data_grid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ApplyConferenceScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ApplyConferenceScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ApplyConferenceScreen> createState() => _ApplyConferenceScreenState();
}

class _ApplyConferenceScreenState extends State<ApplyConferenceScreen> {
  ApplyConferenceService conferenceService = ApplyConferenceService();
  bool searchApproval = false;

  void _searchApprovalChange(bool value) {
    setState(() {
      searchApproval = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      header: Container(
        decoration: kHeaderDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '協議申請一覧',
                style: TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: const Icon(FluentIcons.clear),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
              ),
            ],
          ),
        ),
      ),
      content: Container(
        color: kWhiteColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ToggleSwitch(
                  checked: searchApproval,
                  onChanged: _searchApprovalChange,
                  content: Text(searchApproval ? '承認済み' : '承認待ち'),
                ),
                const SizedBox(width: 4),
                CustomButtonSm(
                  labelText: '新規申請',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  onPressed: () => Navigator.push(
                    context,
                    FluentPageRoute(
                      builder: (context) => ApplyConferenceAddScreen(
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
                stream: conferenceService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  approval: searchApproval,
                ),
                builder: (context, snapshot) {
                  List<ApplyConferenceModel> conferences = [];
                  if (snapshot.hasData) {
                    conferences = conferenceService.generateList(
                      data: snapshot.data,
                      currentGroup: widget.homeProvider.currentGroup,
                    );
                  }
                  return CustomDataGrid(
                    source: ApplyConferenceSource(
                      context: context,
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      conferences: conferences,
                    ),
                    columns: [
                      GridColumn(
                        columnName: 'createdAt',
                        label: const CustomColumnLabel('提出日時'),
                      ),
                      GridColumn(
                        columnName: 'createdUserName',
                        label: const CustomColumnLabel('作成者名'),
                      ),
                      GridColumn(
                        columnName: 'title',
                        label: const CustomColumnLabel('件名'),
                      ),
                      GridColumn(
                        columnName: 'approval',
                        label: const CustomColumnLabel('承認状況'),
                      ),
                      GridColumn(
                        columnName: 'approvedAt',
                        label: const CustomColumnLabel('承認日時'),
                      ),
                      GridColumn(
                        columnName: 'edit',
                        label: const CustomColumnLabel('操作'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}