import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/user.dart';
import 'package:miel_work_web/services/pdf.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_column_link.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class UserSource extends DataGridSource {
  final BuildContext context;
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final List<UserModel> users;
  final Function() getUsers;

  UserSource({
    required this.context,
    required this.loginProvider,
    required this.homeProvider,
    required this.users,
    required this.getUsers,
  }) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = users.map<DataGridRow>((user) {
      return DataGridRow(cells: [
        DataGridCell(
          columnName: 'id',
          value: user.id,
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
    UserModel user = users.singleWhere(
      (e) => e.id == '${row.getCells()[0].value}',
    );
    cells.add(CustomColumnLabel(user.name));
    cells.add(CustomColumnLabel(user.email));
    cells.add(CustomColumnLabel(user.password));
    OrganizationGroupModel? userInGroup;
    if (homeProvider.groups.isNotEmpty) {
      for (OrganizationGroupModel group in homeProvider.groups) {
        if (group.userIds.contains(user.id)) {
          userInGroup = group;
        }
      }
    }
    if (userInGroup != null) {
      cells.add(CustomColumnLabel(userInGroup.name));
    } else {
      cells.add(const CustomColumnLabel(
        '未所属',
        labelColor: kGreyColor,
      ));
    }
    if (user.uid != '') {
      cells.add(CustomColumnLink(
        label: 'ログイン中',
        color: kBlueColor,
        onTap: () => showDialog(
          context: context,
          builder: (context) => AppLogoutDialog(
            loginProvider: loginProvider,
            homeProvider: homeProvider,
            user: user,
            getUsers: getUsers,
          ),
        ),
      ));
    } else {
      cells.add(const CustomColumnLabel(
        '未ログイン',
        labelColor: kGreyColor,
      ));
    }
    if (user.admin) {
      cells.add(const CustomColumnLabel('管理者'));
    } else {
      cells.add(const CustomColumnLabel(''));
    }
    if (user.president) {
      cells.add(const CustomColumnLabel('社長'));
    } else {
      cells.add(const CustomColumnLabel(''));
    }
    cells.add(Row(
      children: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: '編集',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => ModUserDialog(
              loginProvider: loginProvider,
              homeProvider: homeProvider,
              user: user,
              userInGroup: userInGroup,
              getUsers: getUsers,
            ),
          ),
        ),
        const SizedBox(width: 4),
        !user.admin
            ? CustomButton(
                type: ButtonSizeType.sm,
                label: '削除',
                labelColor: kWhiteColor,
                backgroundColor: kRedColor,
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => DelUserDialog(
                    loginProvider: loginProvider,
                    homeProvider: homeProvider,
                    user: user,
                    userInGroup: userInGroup,
                    getUsers: getUsers,
                  ),
                ),
              )
            : const CustomButton(
                type: ButtonSizeType.sm,
                label: '削除',
                labelColor: kWhiteColor,
                backgroundColor: kGreyColor,
              ),
        const SizedBox(width: 4),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '初期設定PDF',
          labelColor: kWhiteColor,
          backgroundColor: kPdfColor,
          onPressed: () async => await PdfService().userDownload(user),
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

class ModUserDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final UserModel user;
  final OrganizationGroupModel? userInGroup;
  final Function() getUsers;

  const ModUserDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.user,
    required this.userInGroup,
    required this.getUsers,
    super.key,
  });

  @override
  State<ModUserDialog> createState() => _ModUserDialogState();
}

class _ModUserDialogState extends State<ModUserDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  OrganizationGroupModel? selectedGroup;
  bool admin = false;
  bool president = false;

  @override
  void initState() {
    nameController.text = widget.user.name;
    emailController.text = widget.user.email;
    passwordController.text = widget.user.password;
    selectedGroup = widget.userInGroup;
    admin = widget.user.admin;
    president = widget.user.president;
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
          label: '保存する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await userProvider.update(
              organization: widget.loginProvider.organization,
              user: widget.user,
              name: nameController.text,
              email: emailController.text,
              password: passwordController.text,
              befGroup: widget.userInGroup,
              aftGroup: selectedGroup,
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
            showMessage(context, 'スタッフ情報が変更されました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class AppLogoutDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final UserModel user;
  final Function() getUsers;

  const AppLogoutDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.user,
    required this.getUsers,
    super.key,
  });

  @override
  State<AppLogoutDialog> createState() => _AppLogoutDialogState();
}

class _AppLogoutDialogState extends State<AppLogoutDialog> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return CustomAlertDialog(
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text('強制的にログアウトさせますか？'),
          ],
        ),
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
          label: 'ログアウト',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await userProvider.updateAppLogout(
              user: widget.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            widget.getUsers();
            if (!mounted) return;
            showMessage(context, '強制的にログアウトさせました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class DelUserDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final UserModel user;
  final OrganizationGroupModel? userInGroup;
  final Function() getUsers;

  const DelUserDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.user,
    required this.userInGroup,
    required this.getUsers,
    super.key,
  });

  @override
  State<DelUserDialog> createState() => _DelUserDialogState();
}

class _DelUserDialogState extends State<DelUserDialog> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          const Text(
            '本当に削除しますか？',
            style: TextStyle(color: kRedColor),
          ),
          const SizedBox(height: 8),
          FormLabel(
            'スタッフ名',
            child: FormValue(widget.user.name),
          ),
          const SizedBox(height: 8),
          FormLabel(
            'メールアドレス',
            child: FormValue(widget.user.email),
          ),
          const SizedBox(height: 8),
          FormLabel(
            'パスワード',
            child: FormValue(widget.user.password),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '所属グループ',
            child: FormValue(widget.userInGroup?.name ?? '未所属'),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '権限',
            child: FormValue(widget.user.admin ? '管理者' : '一般'),
          ),
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
          label: '削除する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await userProvider.delete(
              organization: widget.loginProvider.organization,
              user: widget.user,
              group: widget.userInGroup,
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
            showMessage(context, 'スタッフを削除しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
