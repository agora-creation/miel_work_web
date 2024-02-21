import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/screens/user_source.dart';
import 'package:miel_work_web/services/user.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_data_grid.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class UserScreen extends StatefulWidget {
  final OrganizationModel? organization;
  final OrganizationGroupModel? group;

  const UserScreen({
    required this.organization,
    required this.group,
    super.key,
  });

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserService userService = UserService();

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
                    '『${widget.group?.name}』のスタッフを追加してください。',
                    style: const TextStyle(fontSize: 14),
                  ),
                  CustomButtonSm(
                    labelText: 'スタッフ追加',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AddUserDialog(
                        organization: widget.organization,
                        group: widget.group,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: userService.streamList(
                  organizationId: widget.organization?.id ?? 'error',
                  groupId: widget.group?.id ?? 'error',
                ),
                builder: (context, snapshot) {
                  List<UserModel> users = [];
                  if (snapshot.hasData) {
                    for (DocumentSnapshot<Map<String, dynamic>> doc
                        in snapshot.data!.docs) {
                      users.add(UserModel.fromSnapshot(doc));
                    }
                  }
                  return CustomDataGrid(
                    source: UserSource(
                      context: context,
                      users: users,
                    ),
                    columns: [
                      GridColumn(
                        columnName: 'name',
                        label: const CustomColumnLabel('スタッフ名'),
                      ),
                      GridColumn(
                        columnName: 'email',
                        label: const CustomColumnLabel('メールアドレス'),
                      ),
                      GridColumn(
                        columnName: 'password',
                        label: const CustomColumnLabel('パスワード'),
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

class AddUserDialog extends StatefulWidget {
  final OrganizationModel? organization;
  final OrganizationGroupModel? group;

  const AddUserDialog({
    required this.organization,
    required this.group,
    super.key,
  });

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  UserService userService = UserService();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'スタッフ - 追加',
        style: TextStyle(fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoLabel(
              label: 'スタッフ名',
              child: CustomTextBox(
                controller: nameController,
                placeholder: '例) 山田花子',
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: 'メールアドレス',
              child: CustomTextBox(
                controller: emailController,
                placeholder: '例) yamada@example.jp',
                keyboardType: TextInputType.emailAddress,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: 'パスワード',
              child: CustomTextBox(
                controller: passwordController,
                placeholder: '',
                keyboardType: TextInputType.visiblePassword,
                maxLines: 1,
                obscureText: true,
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
          labelText: '追加する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String id = userService.id();
            userService.create({
              'id': id,
              'organizationId': widget.organization?.id,
              'groupId': widget.group?.id,
              'name': nameController.text,
              'email': emailController.text,
              'password': passwordController.text,
              'uid': '',
              'token': '',
              'createdAt': DateTime.now(),
            });
            if (!mounted) return;
            showMessage(context, 'スタッフを追加しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
