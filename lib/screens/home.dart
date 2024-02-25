import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/chat.dart';
import 'package:miel_work_web/screens/group_setting.dart';
import 'package:miel_work_web/screens/manual.dart';
import 'package:miel_work_web/screens/notice.dart';
import 'package:miel_work_web/screens/plan.dart';
import 'package:miel_work_web/screens/plan_shift.dart';
import 'package:miel_work_web/screens/user.dart';
import 'package:miel_work_web/widgets/custom_header.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _init() {}

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    OrganizationModel? organization = loginProvider.organization;
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
            title: const Text('スケジュール表'),
            body: PlanScreen(
              organization: organization,
              group: homeProvider.currentGroup,
            ),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.view_list),
            title: const Text('シフト表'),
            body: PlanShiftScreen(
              organization: organization,
              group: homeProvider.currentGroup,
            ),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.office_chat),
            title: const Text('チャット'),
            body: ChatScreen(
              organization: organization,
              group: homeProvider.currentGroup,
            ),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.news),
            title: const Text('お知らせ'),
            body: NoticeScreen(
              homeProvider: homeProvider,
              organization: organization,
            ),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.documentation),
            title: const Text('業務マニュアル'),
            body: ManualScreen(
              homeProvider: homeProvider,
              organization: organization,
            ),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.group),
            title: const Text('スタッフ管理'),
            body: UserScreen(
              homeProvider: homeProvider,
              organization: organization,
            ),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('グループ設定'),
            body: GroupSettingScreen(
              homeProvider: homeProvider,
              organization: organization,
            ),
            enabled: homeProvider.currentGroup != null,
          ),
          PaneItemSeparator(),
        ],
      ),
    );
  }
}
