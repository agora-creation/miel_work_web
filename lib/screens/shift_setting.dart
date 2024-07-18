import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/setting_list.dart';
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
  @override
  Widget build(BuildContext context) {
    OrganizationModel? organization = widget.loginProvider.organization;
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        title: const Text(
          'シフト表専用画面設定',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: kBlackColor),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 200,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'シフト表専用画面は、文字通り『シフト表』の機能のみ利用できる専用管理画面です。',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            SettingList(
              label: 'URL',
              value: 'https://miel-work-shift.web.app/',
              onTap: () async {
                Uri url = Uri.parse('https://miel-work-shift.web.app/');
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              },
            ),
            SettingList(
              label: 'ログインID',
              value: organization?.shiftLoginId ?? '',
              onTap: () => showDialog(
                context: context,
                builder: (context) => ModOrganizationShiftLoginIdDialog(
                  loginProvider: widget.loginProvider,
                  homeProvider: widget.homeProvider,
                ),
              ),
              isFirst: false,
            ),
            SettingList(
              label: 'パスワード',
              value: organization?.shiftPassword ?? '',
              onTap: () => showDialog(
                context: context,
                builder: (context) => ModOrganizationShiftPasswordDialog(
                  loginProvider: widget.loginProvider,
                  homeProvider: widget.homeProvider,
                ),
              ),
              isFirst: false,
            ),
          ],
        ),
      ),
    );
  }
}

class ModOrganizationShiftLoginIdDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ModOrganizationShiftLoginIdDialog({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ModOrganizationShiftLoginIdDialog> createState() =>
      _ModOrganizationShiftLoginIdDialogState();
}

class _ModOrganizationShiftLoginIdDialogState
    extends State<ModOrganizationShiftLoginIdDialog> {
  TextEditingController shiftLoginIdController = TextEditingController();

  @override
  void initState() {
    shiftLoginIdController.text =
        widget.loginProvider.organization?.shiftLoginId ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          FormLabel(
            'ログインID',
            child: CustomTextField(
              controller: shiftLoginIdController,
              textInputType: TextInputType.text,
              maxLines: 1,
            ),
          ),
        ],
      ),
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '入力内容を保存',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error =
                await widget.loginProvider.organizationShiftLoginIdUpdate(
              organization: widget.loginProvider.organization,
              shiftLoginId: shiftLoginIdController.text,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            await widget.loginProvider.reload();
            if (!mounted) return;
            showMessage(context, 'ログインIDを変更しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ModOrganizationShiftPasswordDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ModOrganizationShiftPasswordDialog({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ModOrganizationShiftPasswordDialog> createState() =>
      _ModOrganizationShiftPasswordDialogState();
}

class _ModOrganizationShiftPasswordDialogState
    extends State<ModOrganizationShiftPasswordDialog> {
  TextEditingController shiftPasswordController = TextEditingController();

  @override
  void initState() {
    shiftPasswordController.text =
        widget.loginProvider.organization?.shiftPassword ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          FormLabel(
            'パスワード',
            child: CustomTextField(
              controller: shiftPasswordController,
              textInputType: TextInputType.visiblePassword,
              maxLines: 1,
            ),
          ),
        ],
      ),
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '入力内容を保存',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error =
                await widget.loginProvider.organizationShiftPasswordUpdate(
              organization: widget.loginProvider.organization,
              shiftPassword: shiftPasswordController.text,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            await widget.loginProvider.reload();
            if (!mounted) return;
            showMessage(context, 'パスワードを変更しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
