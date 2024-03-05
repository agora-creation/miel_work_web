import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/notice.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/notice.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:provider/provider.dart';

class NoticeDelScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final NoticeModel notice;
  final OrganizationGroupModel? noticeInGroup;

  const NoticeDelScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.notice,
    required this.noticeInGroup,
    super.key,
  });

  @override
  State<NoticeDelScreen> createState() => _NoticeDelScreenState();
}

class _NoticeDelScreenState extends State<NoticeDelScreen> {
  @override
  Widget build(BuildContext context) {
    final noticeProvider = Provider.of<NoticeProvider>(context);
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
                'お知らせを削除',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  CustomButtonSm(
                    labelText: '削除する',
                    labelColor: kWhiteColor,
                    backgroundColor: kRedColor,
                    onPressed: () async {
                      String? error = await noticeProvider.delete(
                        notice: widget.notice,
                      );
                      if (error != null) {
                        if (!mounted) return;
                        showMessage(context, error, false);
                        return;
                      }
                      if (!mounted) return;
                      showMessage(context, 'お知らせを削除しました', true);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(FluentIcons.clear),
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                  ),
                ],
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
              '本当に削除しますか？',
              style: TextStyle(color: kRedColor),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: 'タイトル',
              child: CustomTextBox(
                controller: TextEditingController(
                  text: widget.notice.title,
                ),
                enabled: false,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: 'お知らせ内容',
              child: CustomTextBox(
                controller: TextEditingController(
                  text: widget.notice.content,
                ),
                enabled: false,
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '送信先グループ',
              child: CustomTextBox(
                controller: TextEditingController(
                  text: widget.noticeInGroup?.name,
                ),
                enabled: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
