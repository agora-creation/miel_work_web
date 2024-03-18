import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/apply_project.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/apply_project_add.dart';
import 'package:miel_work_web/screens/apply_project_source.dart';
import 'package:miel_work_web/services/apply_project.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_data_grid.dart';
import 'package:miel_work_web/widgets/custom_tab_view.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ApplyProjectScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ApplyProjectScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ApplyProjectScreen> createState() => _ApplyProjectScreenState();
}

class _ApplyProjectScreenState extends State<ApplyProjectScreen> {
  ApplyProjectService projectService = ApplyProjectService();
  int currentIndex = 0;

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
                '企画申請一覧',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                CustomButtonSm(
                  icon: FluentIcons.add,
                  labelText: '新規申請',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  onPressed: () => Navigator.push(
                    context,
                    FluentPageRoute(
                      builder: (context) => ApplyProjectAddScreen(
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
              child: CustomTabView(
                tabs: [
                  Tab(
                    icon: const Icon(FluentIcons.progress_ring_dots),
                    text: const Text('承認待ち'),
                    semanticLabel: '承認待ち',
                    body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: projectService.streamList(
                        organizationId: widget.loginProvider.organization?.id,
                        approval: 0,
                      ),
                      builder: (context, snapshot) {
                        List<ApplyProjectModel> projects = [];
                        if (snapshot.hasData) {
                          projects = projectService.generateList(
                            data: snapshot.data,
                            currentGroup: widget.homeProvider.currentGroup,
                          );
                        }
                        return CustomDataGrid(
                          source: ApplyProjectSource(
                            context: context,
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            projects: projects,
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
                              width: 200,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Tab(
                    icon: const Icon(FluentIcons.completed_solid),
                    text: const Text('承認済み'),
                    semanticLabel: '承認済み',
                    body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: projectService.streamList(
                        organizationId: widget.loginProvider.organization?.id,
                        approval: 1,
                      ),
                      builder: (context, snapshot) {
                        List<ApplyProjectModel> projects = [];
                        if (snapshot.hasData) {
                          projects = projectService.generateList(
                            data: snapshot.data,
                            currentGroup: widget.homeProvider.currentGroup,
                          );
                        }
                        return CustomDataGrid(
                          source: ApplyProjectSource(
                            context: context,
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            projects: projects,
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
                              width: 200,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Tab(
                    icon: const Icon(FluentIcons.status_error_full),
                    text: const Text('否決'),
                    semanticLabel: '否決',
                    body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: projectService.streamList(
                        organizationId: widget.loginProvider.organization?.id,
                        approval: 9,
                      ),
                      builder: (context, snapshot) {
                        List<ApplyProjectModel> projects = [];
                        if (snapshot.hasData) {
                          projects = projectService.generateList(
                            data: snapshot.data,
                            currentGroup: widget.homeProvider.currentGroup,
                          );
                        }
                        return CustomDataGrid(
                          source: ApplyProjectSource(
                            context: context,
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            projects: projects,
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
                              width: 200,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
                currentIndex: currentIndex,
                onChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
