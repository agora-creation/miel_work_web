import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/login.dart';
import 'package:miel_work_web/screens/user.dart';
import 'package:miel_work_web/widgets/custom_appbar_title.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    OrganizationModel? organization = loginProvider.organization;
    final homeProvider = Provider.of<HomeProvider>(context);

    return NavigationView(
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        title: CustomAppbarTitle(
          organization: organization,
          homeProvider: homeProvider,
          addOnPressed: () => showDialog(
            context: context,
            builder: (context) => AddGroupDialog(
              organization: organization,
              homeProvider: homeProvider,
            ),
          ),
        ),
        actions: Padding(
          padding: const EdgeInsets.all(8),
          child: Align(
            alignment: Alignment.centerRight,
            child: CustomButtonSm(
              labelText: 'ログアウト',
              labelColor: kWhiteColor,
              backgroundColor: kGreyColor,
              onPressed: () => showDialog(
                context: context,
                builder: (context) => LogoutDialog(
                  loginProvider: loginProvider,
                ),
              ),
            ),
          ),
        ),
      ),
      pane: NavigationPane(
        selected: homeProvider.currentIndex,
        onChanged: (index) {
          homeProvider.currentIndexChange(index);
        },
        displayMode: PaneDisplayMode.top,
        items: [
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.group),
            title: const Text('スタッフ管理'),
            body: UserScreen(
              organization: organization,
              group: homeProvider.currentGroup,
            ),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.schedule_event_action),
            title: const Text('スケジュール表'),
            body: const Center(
              child: Text(
                'グループが選択されていません',
                style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.check_list),
            title: const Text('シフト表'),
            body: const Center(
              child: Text(
                'グループが選択されていません',
                style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.timeline_delivery),
            title: const Text('チャット'),
            body: const Center(
              child: Text(
                'グループが選択されていません',
                style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('お知らせ'),
            body: const Center(
              child: Text(
                'グループが選択されていません',
                style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.group),
            title: const Text('グループ設定'),
            body: const Center(
              child: Text(
                'グループが選択されていません',
                style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          PaneItemSeparator(),
        ],
      ),
    );
  }
}

class AddGroupDialog extends StatefulWidget {
  final OrganizationModel? organization;
  final HomeProvider homeProvider;

  const AddGroupDialog({
    required this.organization,
    required this.homeProvider,
    super.key,
  });

  @override
  State<AddGroupDialog> createState() => _AddGroupDialogState();
}

class _AddGroupDialogState extends State<AddGroupDialog> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'グループ - 追加',
        style: TextStyle(fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoLabel(
              label: 'グループ名',
              child: CustomTextBox(
                controller: nameController,
                placeholder: '例) 部署名や役職名など',
                keyboardType: TextInputType.text,
                maxLines: 1,
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
            String? error = await widget.homeProvider.groupCreate(
              organization: widget.organization,
              name: nameController.text,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            widget.homeProvider.setGroups(
              organization: widget.organization,
            );
            if (!mounted) return;
            showMessage(context, 'グループを追加しました', true);
            Navigator.pop(context);
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
            Text('本当にログアウトしますか？'),
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
