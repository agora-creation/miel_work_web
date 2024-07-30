import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/user.dart';
import 'package:miel_work_web/screens/user_source.dart';
import 'package:miel_work_web/services/user.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_data_grid.dart';
import 'package:miel_work_web/widgets/custom_icon_text_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class UserScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const UserScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserService userService = UserService();
  List<UserModel> users = [];

  void _getUsers() async {
    if (widget.homeProvider.currentGroup == null) {
      users = await userService.selectList(
        userIds: widget.loginProvider.organization?.userIds ?? [],
      );
    } else {
      users = await userService.selectList(
        userIds: widget.homeProvider.currentGroup?.userIds ?? [],
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    _getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String organizationName = widget.loginProvider.organization?.name ?? '';
    OrganizationGroupModel? group = widget.homeProvider.currentGroup;
    String groupName = group?.name ?? '';
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        title: const Text(
          'スタッフ一覧',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.xmark,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomIconTextButton(
                  label: 'スタッフを追加',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  leftIcon: FontAwesomeIcons.plus,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AddUserDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      getUsers: _getUsers,
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
                  loginProvider: widget.loginProvider,
                  homeProvider: widget.homeProvider,
                  users: users,
                  getUsers: _getUsers,
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
                    columnName: 'admin',
                    label: const CustomColumnLabel('管理者権限'),
                  ),
                  GridColumn(
                    columnName: 'president',
                    label: const CustomColumnLabel('社長権限'),
                  ),
                  GridColumn(
                    columnName: 'edit',
                    label: const CustomColumnLabel('操作'),
                    width: 300,
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
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final Function() getUsers;

  const AddUserDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.getUsers,
    super.key,
  });

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  OrganizationGroupModel? selectedGroup;
  bool admin = false;
  bool president = false;

  @override
  void initState() {
    selectedGroup = widget.homeProvider.currentGroup;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    List<DropdownMenuItem<OrganizationGroupModel>> groupItems = [];
    if (widget.homeProvider.groups.isNotEmpty) {
      groupItems.add(const DropdownMenuItem(
        value: null,
        child: Text(
          '未所属',
          style: TextStyle(color: kGreyColor),
        ),
      ));
      for (OrganizationGroupModel group in widget.homeProvider.groups) {
        groupItems.add(DropdownMenuItem(
          value: group,
          child: Text(group.name),
        ));
      }
    }
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FormLabel(
            'スタッフ名',
            child: CustomTextField(
              controller: nameController,
              textInputType: TextInputType.text,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          FormLabel(
            'メールアドレス',
            child: CustomTextField(
              controller: emailController,
              textInputType: TextInputType.emailAddress,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          FormLabel(
            'パスワード',
            child: CustomTextField(
              controller: passwordController,
              textInputType: TextInputType.visiblePassword,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '所属グループ',
            child: DropdownButton<OrganizationGroupModel>(
              isExpanded: true,
              value: selectedGroup,
              items: groupItems,
              onChanged: (value) {
                setState(() {
                  selectedGroup = value;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          selectedGroup == null
              ? FormLabel(
                  '管理者権限',
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: kGreyColor),
                        bottom: BorderSide(color: kGreyColor),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    child: CheckboxListTile(
                      value: admin,
                      onChanged: (value) {
                        setState(() {
                          admin = value ?? false;
                        });
                      },
                      title: const Text('管理者にする'),
                    ),
                  ),
                )
              : Container(),
          const SizedBox(height: 8),
          selectedGroup == null
              ? FormLabel(
                  '社長権限',
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: kGreyColor),
                        bottom: BorderSide(color: kGreyColor),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    child: CheckboxListTile(
                      value: president,
                      onChanged: (value) {
                        setState(() {
                          president = value ?? false;
                        });
                      },
                      title: const Text('社長にする'),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '追加する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await userProvider.create(
              organization: widget.loginProvider.organization,
              name: nameController.text,
              email: emailController.text,
              password: passwordController.text,
              group: selectedGroup,
              admin: admin,
              president: president,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            await widget.loginProvider.reload();
            widget.homeProvider.setGroups(
              organizationId: widget.loginProvider.organization?.id ?? 'error',
            );
            widget.getUsers();
            if (!mounted) return;
            showMessage(context, 'スタッフが追加されました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
