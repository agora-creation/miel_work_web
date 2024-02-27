import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/login.dart';
import 'package:miel_work_web/services/user.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
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
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      header: Container(
        decoration: const BoxDecoration(
          color: kWhiteColor,
          border: Border(bottom: BorderSide(color: kGrey300Color)),
        ),
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
                value: widget.loginProvider.user?.name ?? '',
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => AdminDialog(
                    loginProvider: widget.loginProvider,
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

  const AdminDialog({
    required this.loginProvider,
    super.key,
  });

  @override
  State<AdminDialog> createState() => _AdminDialogState();
}

class _AdminDialogState extends State<AdminDialog> {
  UserService userService = UserService();
  List<UserModel> users = [];
  UserModel? selectedUser;

  void _init() async {
    users = await userService.selectList(
      userIds: widget.loginProvider.organization?.userIds ?? [],
    );
    selectedUser = widget.loginProvider.user;
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
        '管理者変更',
        style: TextStyle(fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('変更時、自動的にログアウトします。'),
            const SizedBox(height: 8),
            InfoLabel(
              label: '現在の管理者',
              child: Text('${selectedUser?.name}'),
            ),
            const SizedBox(height: 16),
            const Center(child: Icon(FluentIcons.down)),
            const SizedBox(height: 16),
            ComboBox(
              isExpanded: true,
              value: selectedUser,
              items: users.map((user) {
                return ComboBoxItem(
                  value: user,
                  child: Text(user.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedUser = value;
                });
              },
              placeholder: const Text('スタッフを選択してください'),
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
          labelText: '変更する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await widget.loginProvider.adminChange(
              adminUser: selectedUser,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            await widget.loginProvider.logout();
            if (!mounted) return;
            showMessage(context, '管理者を変更しました', true);
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
