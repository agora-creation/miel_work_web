import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/user.dart';
import 'package:miel_work_web/services/pdf.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_column_link.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
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
        CustomButtonSm(
          labelText: '編集',
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
            ? CustomButtonSm(
                labelText: '削除',
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
            : const CustomButtonSm(
                labelText: '削除',
                labelColor: kWhiteColor,
                backgroundColor: kGreyColor,
              ),
        const SizedBox(width: 4),
        CustomButtonSm(
          labelText: 'PDF印刷',
          labelColor: kBlackColor,
          backgroundColor: kRed200Color,
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
    super.initState();
    nameController.text = widget.user.name;
    emailController.text = widget.user.email;
    passwordController.text = widget.user.password;
    selectedGroup = widget.userInGroup;
    admin = widget.user.admin;
    president = widget.user.president;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    List<ComboBoxItem<OrganizationGroupModel>> groupItems = [];
    if (widget.homeProvider.groups.isNotEmpty) {
      groupItems.add(const ComboBoxItem(
        value: null,
        child: Text(
          '未所属',
          style: TextStyle(color: kGreyColor),
        ),
      ));
      for (OrganizationGroupModel group in widget.homeProvider.groups) {
        groupItems.add(ComboBoxItem(
          value: group,
          child: Text(group.name),
        ));
      }
    }
    return ContentDialog(
      title: const Text(
        'スタッフ情報を編集',
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
                placeholder: const Text(
                  '未所属',
                  style: TextStyle(color: kGreyColor),
                ),
              ),
            ),
            const SizedBox(height: 8),
            selectedGroup == null
                ? InfoLabel(
                    label: '管理者権限',
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: kGreyColor),
                          bottom: BorderSide(color: kGreyColor),
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      width: double.infinity,
                      child: Checkbox(
                        checked: admin,
                        onChanged: (value) {
                          setState(() {
                            admin = value ?? false;
                          });
                        },
                        content: const Text('このスタッフを管理者にする'),
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(height: 8),
            selectedGroup == null
                ? InfoLabel(
                    label: '社長権限',
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: kGreyColor),
                          bottom: BorderSide(color: kGreyColor),
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      width: double.infinity,
                      child: Checkbox(
                        checked: president,
                        onChanged: (value) {
                          setState(() {
                            president = value ?? false;
                          });
                        },
                        content: const Text('このスタッフを社長にする'),
                      ),
                    ),
                  )
                : Container(),
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
          labelText: '入力内容を保存',
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
            showMessage(context, 'スタッフ情報を編集しました', true);
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
    return ContentDialog(
      title: const Text(
        'スマホアプリからログアウト',
        style: TextStyle(fontSize: 18),
      ),
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('強制的にログアウトさせますか？'),
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
          labelText: 'ログアウト',
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
    return ContentDialog(
      title: const Text(
        'スタッフを削除',
        style: TextStyle(fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '本当に削除しますか？',
              style: TextStyle(color: kRedColor),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: 'スタッフ名',
              child: Container(
                color: kGrey200Color,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text(widget.user.name),
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: 'メールアドレス',
              child: Container(
                color: kGrey200Color,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text(widget.user.email),
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: 'パスワード',
              child: Container(
                color: kGrey200Color,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text(widget.user.password),
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '所属グループ',
              child: Container(
                color: kGrey200Color,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text(widget.userInGroup?.name ?? '未所属'),
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '権限',
              child: Container(
                color: kGrey200Color,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text(widget.user.admin ? '管理者' : '一般'),
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
          labelText: '削除する',
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
