import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_setting_list.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
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
              value: organization?.shiftLoginId ?? '',
              onTap: () => showDialog(
                context: context,
                builder: (context) => ModOrganizationShiftLoginIdDialog(
                  loginProvider: widget.loginProvider,
                ),
              ),
              isFirst: false,
            ),
            CustomSettingList(
              label: 'パスワード',
              value: organization?.shiftPassword ?? '',
              onTap: () => showDialog(
                context: context,
                builder: (context) => ModOrganizationShiftPasswordDialog(
                  loginProvider: widget.loginProvider,
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

  const ModOrganizationShiftLoginIdDialog({
    required this.loginProvider,
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
    super.initState();
    shiftLoginIdController.text =
        widget.loginProvider.organization?.shiftLoginId ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoLabel(
              label: 'ログインID',
              child: CustomTextBox(
                controller: shiftLoginIdController,
                placeholder: '',
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
          labelText: '入力内容を保存',
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

  const ModOrganizationShiftPasswordDialog({
    required this.loginProvider,
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
    super.initState();
    shiftPasswordController.text =
        widget.loginProvider.organization?.shiftPassword ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoLabel(
              label: 'パスワード',
              child: CustomTextBox(
                controller: shiftPasswordController,
                placeholder: '',
                keyboardType: TextInputType.visiblePassword,
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
          labelText: '入力内容を保存',
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
