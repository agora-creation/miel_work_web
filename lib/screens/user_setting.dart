import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/login.dart';
import 'package:miel_work_web/services/user.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_checkbox.dart';
import 'package:miel_work_web/widgets/custom_setting_list.dart';
import 'package:miel_work_web/widgets/link_text.dart';

class UserSettingScreen extends StatefulWidget {
  final LoginProvider loginProvider;

  const UserSettingScreen({
    required this.loginProvider,
    super.key,
  });

  @override
  State<UserSettingScreen> createState() => _UserSettingScreenState();
}

class _UserSettingScreenState extends State<UserSettingScreen> {
  UserService userService = UserService();
  List<UserModel> users = [];
  String usersText = '';

  void _init() async {
    users = await userService.selectList(
      userIds: widget.loginProvider.organization?.userIds ?? [],
    );
    for (UserModel user in users) {
      List<String> adminUserIds =
          widget.loginProvider.organization?.adminUserIds ?? [];
      if (adminUserIds.contains(user.id)) {
        if (usersText != '') usersText += ',';
        usersText += user.name;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
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
                '管理者設定',
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSettingList(
                label: '現在の管理者',
                value: usersText,
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => AdminDialog(
                    loginProvider: widget.loginProvider,
                    users: users,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              LinkText(
                label: 'ログアウト',
                color: kRedColor,
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => LogoutDialog(
                    loginProvider: widget.loginProvider,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final List<UserModel> users;

  const AdminDialog({
    required this.loginProvider,
    required this.users,
    super.key,
  });

  @override
  State<AdminDialog> createState() => _AdminDialogState();
}

class _AdminDialogState extends State<AdminDialog> {
  List<UserModel> selectedUsers = [];

  void _init() async {
    for (UserModel user in widget.users) {
      List<String> adminUserIds =
          widget.loginProvider.organization?.adminUserIds ?? [];
      if (adminUserIds.contains(user.id)) {
        selectedUsers.add(user);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        '管理者を選択する',
        style: TextStyle(fontSize: 18),
      ),
      content: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kGrey300Color),
        ),
        height: 300,
        child: ListView.builder(
          itemCount: widget.users.length,
          itemBuilder: (context, index) {
            UserModel user = widget.users[index];
            return CustomCheckbox(
              label: user.name,
              checked: selectedUsers.contains(user),
              onChanged: (value) {
                if (selectedUsers.contains(user)) {
                  selectedUsers.remove(user);
                } else {
                  selectedUsers.add(user);
                }
                setState(() {});
              },
            );
          },
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
            String? error = await widget.loginProvider.updateAdminUserIds(
              selectedUsers: selectedUsers,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            await widget.loginProvider.logout();
            if (!mounted) return;
            showMessage(context, '管理者を選択しました', true);
            Navigator.pushReplacement(
              context,
              FluentPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class LogoutDialog extends StatefulWidget {
  final LoginProvider loginProvider;

  const LogoutDialog({
    required this.loginProvider,
    super.key,
  });

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'ログアウト',
        style: TextStyle(fontSize: 18),
      ),
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text('本当にログアウトしますか？')),
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
            await widget.loginProvider.logout();
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              FluentPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
