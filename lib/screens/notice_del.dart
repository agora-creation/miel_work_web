import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/notice.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/notice.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
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
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: kBlackColor,
            size: 16,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'お知らせを削除',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: '削除する',
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
          const SizedBox(width: 8),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 200,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormLabel(
                'タイトル',
                child: FormValue(widget.notice.title),
              ),
              const SizedBox(height: 8),
              FormLabel(
                'お知らせ内容',
                child: FormValue(widget.notice.content),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '送信先グループ',
                child: FormValue(widget.noticeInGroup?.name ?? 'グループの指定なし'),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付ファイル',
                child: FormValue(widget.notice.file),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
