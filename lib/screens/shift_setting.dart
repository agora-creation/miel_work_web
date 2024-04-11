import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/services/config.dart';
import 'package:miel_work_web/widgets/custom_setting_list.dart';
import 'package:url_launcher/url_launcher.dart';

class ShiftSettingScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ShiftSettingScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ShiftSettingScreen> createState() => _ShiftSettingScreenState();
}

class _ShiftSettingScreenState extends State<ShiftSettingScreen> {
  String loginId = '';
  String password = '';

  void _getData() async {
    List<String> data = await ConfigService().getShiftLoginData();
    loginId = data.first;
    password = data.last;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getData();
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
                'シフト表専用画面設定',
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'シフト表専用画面は、文字通り『シフト表』の機能のみ利用できる専用管理画面です。',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            CustomSettingList(
              label: 'URL',
              value: 'https://miel-work-shift.web.app/',
              onTap: () async {
                Uri url = Uri.parse('https://miel-work-shift.web.app/');
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              },
            ),
            CustomSettingList(
              label: 'ログインID',
              value: loginId,
              onTap: () {},
              isFirst: false,
            ),
            CustomSettingList(
              label: 'パスワード',
              value: password,
              onTap: () {},
              isFirst: false,
            ),
          ],
        ),
      ),
    );
  }
}
