import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/notice.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/notice.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/link_text.dart';
import 'package:path/path.dart' as p;
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
              IconButton(
                icon: const Icon(FluentIcons.chevron_left),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                'お知らせを削除',
                style: TextStyle(fontSize: 16),
              ),
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
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      content: Container(
        color: kWhiteColor,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 200,
        ),
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
              child: Container(
                color: kGrey200Color,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text(widget.notice.title),
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: 'お知らせ内容',
              child: Container(
                color: kGrey200Color,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text(widget.notice.content),
              ),
            ),
            const SizedBox(height: 8),
            InfoLabel(
              label: '送信先グループ',
              child: Container(
                color: kGrey200Color,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Text(widget.noticeInGroup?.name ?? '全てのグループ'),
              ),
            ),
            const SizedBox(height: 8),
            widget.notice.file != ''
                ? LinkText(
                    label: '添付ファイル',
                    color: kBlueColor,
                    onTap: () {
                      File file = File(widget.notice.file);
                      downloadFile(
                        url: widget.notice.file,
                        name: p.basename(file.path),
                      );
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
