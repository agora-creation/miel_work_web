import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/services/organization_group.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_setting_list.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:miel_work_web/widgets/link_text.dart';
import 'package:provider/provider.dart';

class GroupSettingScreen extends StatefulWidget {
  final HomeProvider homeProvider;
  final OrganizationModel? organization;

  const GroupSettingScreen({
    required this.homeProvider,
    required this.organization,
    super.key,
  });

  @override
  State<GroupSettingScreen> createState() => _GroupSettingScreenState();
}

class _GroupSettingScreenState extends State<GroupSettingScreen> {
  @override
  Widget build(BuildContext context) {
    OrganizationGroupModel? group = widget.homeProvider.currentGroup;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSettingList(
                label: 'グループ名',
                value: group?.name ?? '',
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => ModGroupNameDialog(
                    organization: widget.organization,
                    group: group,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              LinkText(
                label: 'このグループを削除',
                color: kRedColor,
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => DelGroupDialog(
                    organization: widget.organization,
                    group: group,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModGroupNameDialog extends StatefulWidget {
  final OrganizationModel? organization;
  final OrganizationGroupModel? group;

  const ModGroupNameDialog({
    required this.organization,
    required this.group,
    super.key,
  });

  @override
  State<ModGroupNameDialog> createState() => _ModGroupNameDialogState();
}

class _ModGroupNameDialogState extends State<ModGroupNameDialog> {
  OrganizationGroupService groupService = OrganizationGroupService();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.group?.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return ContentDialog(
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
          labelText: '入力内容を保存',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await homeProvider.groupUpdate(
              organization: widget.organization,
              group: widget.group,
              name: nameController.text,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, 'グループ名を変更しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class DelGroupDialog extends StatefulWidget {
  final OrganizationModel? organization;
  final OrganizationGroupModel? group;

  const DelGroupDialog({
    required this.organization,
    required this.group,
    super.key,
  });

  @override
  State<DelGroupDialog> createState() => _DelGroupDialogState();
}

class _DelGroupDialogState extends State<DelGroupDialog> {
  OrganizationGroupService groupService = OrganizationGroupService();

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return ContentDialog(
      title: const Text(
        'グループを削除する',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: Text('本当に削除しますか？')),
          const SizedBox(height: 8),
          InfoLabel(
            label: 'グループ名',
            child: Text(widget.group?.name ?? ''),
          ),
        ],
      ),
      actions: [
        CustomButtonSm(
          labelText: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButtonSm(
          labelText: '削除する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await homeProvider.groupDelete(
              organization: widget.organization,
              group: widget.group,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            homeProvider.currentGroupClear();
            if (!mounted) return;
            showMessage(context, 'グループを削除しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
