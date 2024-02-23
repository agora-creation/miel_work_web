import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/user.dart';
import 'package:miel_work_web/screens/user_source.dart';
import 'package:miel_work_web/services/user.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_data_grid.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class UserScreen extends StatefulWidget {
  final HomeProvider homeProvider;
  final OrganizationModel? organization;
  final OrganizationGroupModel? group;

  const UserScreen({
    required this.homeProvider,
    required this.organization,
    required this.group,
    super.key,
  });

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserService userService = UserService();
  List<UserModel> users = [];

  void _getUses() async {
    List<UserModel> tmpUsers = [];
    if (widget.group == null) {
      tmpUsers = await userService.selectList(
        userIds: widget.organization?.userIds ?? [],
      );
    } else {
      tmpUsers = await userService.selectList(
        userIds: widget.group?.userIds ?? [],
      );
    }
    setState(() {
      users = tmpUsers;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUses();
  }

  @override
  Widget build(BuildContext context) {
    String organizationName = widget.organization?.name ?? '';
    String groupName = widget.group?.name ?? '';
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '『$organizationName $groupName』に所属しているスタッフを表示しています。',
                  style: const TextStyle(fontSize: 14),
                ),
                CustomButtonSm(
                  labelText: 'スタッフを追加',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AddUserDialog(
                      organization: widget.organization,
                      group: widget.group,
                      getUsers: _getUses,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: CustomDataGrid(
                source: UserSource(
                  context: context,
                  users: users,
                  groups: widget.homeProvider.groups,
                  getUsers: _getUses,
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
                    columnName: 'group',
                    label: const CustomColumnLabel('所属グループ'),
                  ),
                  GridColumn(
                    columnName: 'uid',
                    label: const CustomColumnLabel('スマホアプリ'),
                  ),
                  GridColumn(
                    columnName: 'edit',
                    label: const CustomColumnLabel('操作'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddUserDialog extends StatefulWidget {
  final OrganizationModel? organization;
  final OrganizationGroupModel? group;
  final Function() getUsers;

  const AddUserDialog({
    required this.organization,
    required this.group,
    required this.getUsers,
    super.key,
  });

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  OrganizationGroupModel? selectedGroup;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedGroup = widget.group;
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    List<ComboBoxItem<OrganizationGroupModel>> groupItems = [];
    if (homeProvider.groups.isNotEmpty) {
      groupItems.add(const ComboBoxItem(
        value: null,
        child: Text('グループ未選択'),
      ));
      for (OrganizationGroupModel group in homeProvider.groups) {
        groupItems.add(ComboBoxItem(
          value: group,
          child: Text(group.name),
        ));
      }
    }
    return ContentDialog(
      title: const Text(
        'スタッフを追加する',
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
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '所属グループ',
              child: ComboBox<OrganizationGroupModel>(
                isExpanded: true,
                value: selectedGroup,
                items: groupItems,
                onChanged: (value) {
                  setState(() {
                    selectedGroup = value;
                  });
                },
                placeholder: const Text('グループ未選択'),
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
            String? error = await userProvider.create(
              organization: widget.organization,
              name: nameController.text,
              email: emailController.text,
              password: passwordController.text,
              group: selectedGroup,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            await loginProvider.reload();
            homeProvider.setGroups(
              organizationId: selectedGroup?.organizationId ?? 'error',
            );
            widget.getUsers();
            if (!mounted) return;
            showMessage(context, 'スタッフを追加しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
