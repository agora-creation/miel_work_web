import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/login.dart';
import 'package:miel_work_web/screens/shift_setting.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_icon_button_sm.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomHeader extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const CustomHeader({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  @override
  void initState() {
    super.initState();
    widget.homeProvider.setGroups(
      organizationId: widget.loginProvider.organization?.id ?? 'error',
      group: widget.loginProvider.group,
      isAllGroup: widget.loginProvider.isAllGroup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    String organizationName = widget.loginProvider.organization?.name ?? '';
    String userName = widget.loginProvider.user?.name ?? '';
    List<ComboBoxItem<OrganizationGroupModel>> groupItems = [];
    if (widget.homeProvider.groups.isNotEmpty) {
      groupItems.add(const ComboBoxItem(
        value: null,
        child: Text(
          'グループの指定なし',
          style: TextStyle(color: kGreyColor),
        ),
      ));
      for (OrganizationGroupModel group in widget.homeProvider.groups) {
        groupItems.add(ComboBoxItem(
          value: group,
          child: Text(group.name),
        ));
      }
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                organizationName,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  ComboBox<OrganizationGroupModel>(
                    value: widget.homeProvider.currentGroup,
                    items: groupItems,
                    onChanged: (value) {
                      widget.homeProvider.currentGroupChange(value);
                    },
                    placeholder: const Text(
                      'グループの指定なし',
                      style: TextStyle(color: kGreyColor),
                    ),
                  ),
                  const SizedBox(width: 2),
                  CustomIconButtonSm(
                    icon: FluentIcons.add,
                    iconColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AddGroupDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              CustomButtonSm(
                icon: FluentIcons.survey_questions,
                labelText: '操作マニュアル',
                labelColor: kBlackColor,
                backgroundColor: kGreen200Color,
                onPressed: () async {
                  Uri url =
                      Uri.parse('https://agora-c.com/miel-work/manual_web.pdf');
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
              ),
              const SizedBox(width: 4),
              CustomButtonSm(
                icon: FluentIcons.calculated_table,
                labelText: 'メーター検針',
                labelColor: kBlackColor,
                backgroundColor: kYellowColor,
                onPressed: () async {
                  Uri url = Uri.parse('https://hirome.co.jp/meter/system/');
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
              ),
              const SizedBox(width: 4),
              CustomButtonSm(
                icon: FluentIcons.project_management,
                labelText: 'シフト表専用画面設定',
                labelColor: kBlackColor,
                backgroundColor: kLightGreenColor,
                onPressed: () => showBottomUpScreen(
                  context,
                  ShiftSettingScreen(
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              CustomButtonSm(
                icon: FluentIcons.sign_out,
                labelText: '$userNameでログイン中',
                labelColor: kWhiteColor,
                backgroundColor: kGreyColor,
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => LogoutDialog(
                    loginProvider: widget.loginProvider,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddGroupDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const AddGroupDialog({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<AddGroupDialog> createState() => _AddGroupDialogState();
}

class _AddGroupDialogState extends State<AddGroupDialog> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'グループを追加',
        style: TextStyle(fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoLabel(
              label: 'グループ名',
              child: CustomTextBox(
                controller: nameController,
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
          labelText: '追加する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await widget.homeProvider.groupCreate(
              organization: widget.loginProvider.organization,
              name: nameController.text,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, 'グループを追加しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class LogoutDialog extends StatefulWidget {
  final LoginProvider loginProvider;

  const LogoutDialog({
    required this.loginProvider,
    super.key,
  });

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'ログアウト',
        style: TextStyle(fontSize: 18),
      ),
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('本当にログアウトしますか？'),
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
          labelText: 'ログアウト',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            await widget.loginProvider.logout();
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              FluentPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
