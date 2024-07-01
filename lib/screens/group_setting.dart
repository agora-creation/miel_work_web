import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/services/organization_group.dart';
import 'package:miel_work_web/widgets/animation_background.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_setting_list.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:miel_work_web/widgets/link_text.dart';

class GroupSettingScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const GroupSettingScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<GroupSettingScreen> createState() => _GroupSettingScreenState();
}

class _GroupSettingScreenState extends State<GroupSettingScreen> {
  @override
  Widget build(BuildContext context) {
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
                  CustomSettingList(
                    label: 'グループ名',
                    value: groupName,
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => ModNameDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                        group: group,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  widget.loginProvider.isAllGroup()
                      ? LinkText(
                          label: 'このグループを削除',
                          color: kRedColor,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => DelDialog(
                              loginProvider: widget.loginProvider,
                              homeProvider: widget.homeProvider,
                              group: group,
                            ),
                          ),
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

class ModNameDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final OrganizationGroupModel? group;

  const ModNameDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.group,
    super.key,
  });

  @override
  State<ModNameDialog> createState() => _ModNameDialogState();
}

class _ModNameDialogState extends State<ModNameDialog> {
  OrganizationGroupService groupService = OrganizationGroupService();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.group?.name ?? '';
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
            String? error = await widget.homeProvider.groupNameUpdate(
              organization: widget.loginProvider.organization,
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

class DelDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final OrganizationGroupModel? group;

  const DelDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.group,
    super.key,
  });

  @override
  State<DelDialog> createState() => _DelDialogState();
}

class _DelDialogState extends State<DelDialog> {
  OrganizationGroupService groupService = OrganizationGroupService();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'グループを削除',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '本当に削除しますか？',
            style: TextStyle(color: kRedColor),
          ),
          const SizedBox(height: 8),
          InfoLabel(
            label: 'グループ名',
            child: Container(
              color: kGrey200Color,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: Text(widget.group?.name ?? ''),
            ),
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
            String? error = await widget.homeProvider.groupDelete(
              organization: widget.loginProvider.organization,
              group: widget.group,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            widget.homeProvider.currentGroupClear();
            if (!mounted) return;
            showMessage(context, 'グループを削除しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
