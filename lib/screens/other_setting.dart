import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/widgets/animation_background.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_setting_list.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';

class OtherSettingScreen extends StatefulWidget {
  final LoginProvider loginProvider;

  const OtherSettingScreen({
    required this.loginProvider,
    super.key,
  });

  @override
  State<OtherSettingScreen> createState() => _OtherSettingScreenState();
}

class _OtherSettingScreenState extends State<OtherSettingScreen> {
  @override
  Widget build(BuildContext context) {
    OrganizationModel? organization = widget.loginProvider.organization;
    return Stack(
      children: [
        const AnimationBackground(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '『${organization?.name}』として、タブレットアプリを利用する際、以下のログイン情報が必要になります。'),
                  CustomSettingList(
                    label: 'ログインID',
                    value: organization?.loginId ?? '',
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => ModLoginIdDialog(
                        loginProvider: widget.loginProvider,
                      ),
                    ),
                  ),
                  CustomSettingList(
                    label: 'パスワード',
                    value: organization?.password ?? '',
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => ModPasswordDialog(
                        loginProvider: widget.loginProvider,
                      ),
                    ),
                    isFirst: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ModLoginIdDialog extends StatefulWidget {
  final LoginProvider loginProvider;

  const ModLoginIdDialog({
    required this.loginProvider,
    super.key,
  });

  @override
  State<ModLoginIdDialog> createState() => _ModLoginIdDialogState();
}

class _ModLoginIdDialogState extends State<ModLoginIdDialog> {
  TextEditingController loginIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loginIdController.text = widget.loginProvider.organization?.loginId ?? '';
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
                controller: loginIdController,
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
                await widget.loginProvider.organizationLoginIdUpdate(
              organization: widget.loginProvider.organization,
              loginId: loginIdController.text,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, 'ログインIDを変更しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ModPasswordDialog extends StatefulWidget {
  final LoginProvider loginProvider;

  const ModPasswordDialog({
    required this.loginProvider,
    super.key,
  });

  @override
  State<ModPasswordDialog> createState() => _ModPasswordDialogState();
}

class _ModPasswordDialogState extends State<ModPasswordDialog> {
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    passwordController.text = widget.loginProvider.organization?.password ?? '';
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
                controller: passwordController,
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
                await widget.loginProvider.organizationPasswordUpdate(
              organization: widget.loginProvider.organization,
              password: passwordController.text,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, 'パスワードを変更しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
