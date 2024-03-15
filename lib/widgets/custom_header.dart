import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/apply_conference.dart';
import 'package:miel_work_web/screens/apply_project.dart';
import 'package:miel_work_web/screens/apply_proposal.dart';
import 'package:miel_work_web/screens/user_setting.dart';
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
        child: Text('グループ未選択'),
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
              ComboBox<OrganizationGroupModel>(
                value: widget.homeProvider.currentGroup,
                items: groupItems,
                onChanged: (value) {
                  widget.homeProvider.currentGroupChange(value);
                },
                placeholder: const Text('グループ未選択'),
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
              const SizedBox(width: 8),
              const Text(
                '管理画面',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Row(
            children: [
              CustomButtonSm(
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
                labelText: '稟議申請',
                labelColor: kBlackColor,
                backgroundColor: kOrange300Color,
                onPressed: () => showBottomUpScreen(
                  context,
                  ApplyProposalScreen(
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              CustomButtonSm(
                labelText: '協議・報告申請',
                labelColor: kBlackColor,
                backgroundColor: kOrange300Color,
                onPressed: () => showBottomUpScreen(
                  context,
                  ApplyConferenceScreen(
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              CustomButtonSm(
                labelText: '企画申請',
                labelColor: kBlackColor,
                backgroundColor: kOrange300Color,
                onPressed: () => showBottomUpScreen(
                  context,
                  ApplyProjectScreen(
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              CustomButtonSm(
                labelText: '$userNameでログイン中',
                labelColor: kWhiteColor,
                backgroundColor: kGreyColor,
                onPressed: () => showBottomUpScreen(
                  context,
                  UserSettingScreen(
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
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
