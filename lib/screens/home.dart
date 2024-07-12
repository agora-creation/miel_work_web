import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/apply.dart';
import 'package:miel_work_web/screens/chat.dart';
import 'package:miel_work_web/screens/group_setting.dart';
import 'package:miel_work_web/screens/notice.dart';
import 'package:miel_work_web/screens/plan.dart';
import 'package:miel_work_web/screens/problem.dart';
import 'package:miel_work_web/screens/user.dart';
import 'package:miel_work_web/widgets/custom_header.dart';
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
    final homeProvider = Provider.of<HomeProvider>(context);

    return NavigationView(
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        title: CustomHeader(
          loginProvider: loginProvider,
          homeProvider: homeProvider,
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
            icon: const Icon(FluentIcons.calendar),
            title: const Text('スケジュールカレンダー'),
            body: PlanScreen(
              loginProvider: loginProvider,
              homeProvider: homeProvider,
            ),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.office_chat),
            title: const Text('チャット'),
            body: ChatScreen(
              loginProvider: loginProvider,
              homeProvider: homeProvider,
            ),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.news),
            title: const Text('お知らせ'),
            body: NoticeScreen(
              loginProvider: loginProvider,
              homeProvider: homeProvider,
            ),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.document_approval),
            title: const Text('各種申請'),
            body: ApplyScreen(
              loginProvider: loginProvider,
              homeProvider: homeProvider,
            ),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.emoji_disappointed),
            title: const Text('クレーム／要望'),
            body: ProblemScreen(
              loginProvider: loginProvider,
              homeProvider: homeProvider,
            ),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.document_approval),
            title: const Text('業務日報'),
            body: Container(),
            enabled: false,
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.list),
            title: const Text('落とし物'),
            body: Container(),
            enabled: false,
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.list),
            title: const Text('貸出／返却'),
            body: Container(),
            enabled: false,
          ),
          PaneItemSeparator(),
          PaneItem(
              icon: const Icon(FluentIcons.group),
              title: const Text('スタッフ管理'),
              body: UserScreen(
                loginProvider: loginProvider,
                homeProvider: homeProvider,
              ),
              enabled: loginProvider.user?.admin == true),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('グループ設定'),
            body: GroupSettingScreen(
              loginProvider: loginProvider,
              homeProvider: homeProvider,
            ),
            enabled: loginProvider.user?.admin == true &&
                homeProvider.currentGroup != null,
          ),
        ],
      ),
    );
  }
}
