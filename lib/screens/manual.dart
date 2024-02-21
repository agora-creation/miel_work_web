import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/manual.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/screens/manual_source.dart';
import 'package:miel_work_web/services/manual.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_data_grid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ManualScreen extends StatefulWidget {
  final OrganizationModel? organization;
  final OrganizationGroupModel? group;

  const ManualScreen({
    required this.organization,
    required this.group,
    super.key,
  });

  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  ManualService manualService = ManualService();

  @override
  Widget build(BuildContext context) {
    if (widget.group == null) {
      return const Center(
        child: Text(
          'グループが選択されていません',
          style: TextStyle(
            color: kWhiteColor,
            fontSize: 18,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '『${widget.group?.name}』の業務マニュアルをPDF形式で作成し、ここに登録してください。',
                    style: const TextStyle(fontSize: 14),
                  ),
                  CustomButtonSm(
                    labelText: 'ファイル追加',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 8),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: manualService.streamList(
                  organizationId: widget.organization?.id ?? 'error',
                  groupId: widget.group?.id ?? 'error',
                ),
                builder: (context, snapshot) {
                  List<ManualModel> manuals = [];
                  if (snapshot.hasData) {
                    for (DocumentSnapshot<Map<String, dynamic>> doc
                        in snapshot.data!.docs) {
                      manuals.add(ManualModel.fromSnapshot(doc));
                    }
                  }
                  return CustomDataGrid(
                    source: ManualSource(
                      context: context,
                      manuals: manuals,
                    ),
                    columns: [
                      GridColumn(
                        columnName: 'title',
                        label: const CustomColumnLabel('タイトル'),
                      ),
                      GridColumn(
                        columnName: 'file',
                        label: const CustomColumnLabel('ファイル'),
                      ),
                      GridColumn(
                        columnName: 'edit',
                        label: const CustomColumnLabel('操作'),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
