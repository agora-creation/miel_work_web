import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/widgets/animation_background.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_setting_list.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';

class TabletSettingScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const TabletSettingScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<TabletSettingScreen> createState() => _TabletSettingScreenState();
}

class _TabletSettingScreenState extends State<TabletSettingScreen> {
  @override
  Widget build(BuildContext context) {
    OrganizationModel? organization = widget.loginProvider.organization;
    String organizationName = organization?.name ?? '';
    OrganizationGroupModel? group = widget.homeProvider.currentGroup;
    String groupName = group?.name ?? '';
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
                  const Text(
                    '『ひろめWORK』には専用のタブレットアプリが存在します。',
                  ),
                  Text(
                    '『$organizationName』としてログインすると、スタッフ全員の勤怠打刻が可能です。',
                  ),
                  widget.homeProvider.currentGroup != null
                      ? Text(
                          '『$organizationName $groupName』としてログインすると、$groupNameに所属しているスタッフ限定の勤怠打刻が可能です。',
                        )
                      : Container(),
                  const SizedBox(height: 8),
                  Text(
                    '『$organizationName』のログイン情報',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  CustomSettingList(
                    label: 'ログインID',
                    value: organization?.loginId ?? '',
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => ModOrganizationLoginIdDialog(
                        loginProvider: widget.loginProvider,
                      ),
                    ),
                  ),
                  CustomSettingList(
                    label: 'パスワード',
                    value: organization?.password ?? '',
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => ModOrganizationPasswordDialog(
                        loginProvider: widget.loginProvider,
                      ),
                    ),
                    isFirst: false,
                  ),
                  const SizedBox(height: 16),
                  widget.homeProvider.currentGroup != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '『$organizationName $groupName』のログイン情報',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            CustomSettingList(
                              label: 'ログインID',
                              value: group?.loginId ?? '',
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => ModGroupLoginIdDialog(
                                  loginProvider: widget.loginProvider,
                                  homeProvider: widget.homeProvider,
                                  group: group,
                                ),
                              ),
                            ),
                            CustomSettingList(
                              label: 'パスワード',
                              value: group?.password ?? '',
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => ModGroupPasswordDialog(
                                  loginProvider: widget.loginProvider,
                                  homeProvider: widget.homeProvider,
                                  group: group,
                                ),
                              ),
                              isFirst: false,
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ModOrganizationLoginIdDialog extends StatefulWidget {
  final LoginProvider loginProvider;

  const ModOrganizationLoginIdDialog({
    required this.loginProvider,
    super.key,
  });

  @override
  State<ModOrganizationLoginIdDialog> createState() =>
      _ModOrganizationLoginIdDialogState();
}

class _ModOrganizationLoginIdDialogState
    extends State<ModOrganizationLoginIdDialog> {
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

class ModOrganizationPasswordDialog extends StatefulWidget {
  final LoginProvider loginProvider;

  const ModOrganizationPasswordDialog({
    required this.loginProvider,
    super.key,
  });

  @override
  State<ModOrganizationPasswordDialog> createState() =>
      _ModOrganizationPasswordDialogState();
}

class _ModOrganizationPasswordDialogState
    extends State<ModOrganizationPasswordDialog> {
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

class ModGroupLoginIdDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final OrganizationGroupModel? group;

  const ModGroupLoginIdDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.group,
    super.key,
  });

  @override
  State<ModGroupLoginIdDialog> createState() => _ModGroupLoginIdDialogState();
}

class _ModGroupLoginIdDialogState extends State<ModGroupLoginIdDialog> {
  TextEditingController loginIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loginIdController.text = widget.group?.loginId ?? '';
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
            String? error = await widget.homeProvider.groupLoginIdUpdate(
              organization: widget.loginProvider.organization,
              group: widget.group,
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

class ModGroupPasswordDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final OrganizationGroupModel? group;

  const ModGroupPasswordDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.group,
    super.key,
  });

  @override
  State<ModGroupPasswordDialog> createState() => _ModGroupPasswordDialogState();
}

class _ModGroupPasswordDialogState extends State<ModGroupPasswordDialog> {
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    passwordController.text = widget.group?.password ?? '';
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
            String? error = await widget.homeProvider.groupPasswordUpdate(
              organization: widget.loginProvider.organization,
              group: widget.group,
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
