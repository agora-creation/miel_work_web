import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_setting_list.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:miel_work_web/widgets/link_text.dart';

class GroupSettingScreen extends StatefulWidget {
  final OrganizationModel? organization;
  final OrganizationGroupModel? group;

  const GroupSettingScreen({
    required this.organization,
    required this.group,
    super.key,
  });

  @override
  State<GroupSettingScreen> createState() => _GroupSettingScreenState();
}

class _GroupSettingScreenState extends State<GroupSettingScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.group == null) {
      return const Center(
        child: Text(
          'グループが選択されていません',
          style: TextStyle(
            color: kWhiteColor,
            fontSize: 18,
          ),
        ),
      );
    }
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
                value: widget.group?.name ?? '',
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => ModGroupNameDialog(
                    organization: widget.organization,
                    group: widget.group,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              LinkText(
                label: 'このグループを削除',
                color: kRedColor,
                onTap: () {},
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
  TextEditingController nameController = TextEditingController();

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
          labelText: '追加する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            // String id = userService.id();
            // userService.create({
            //   'id': id,
            //   'organizationId': widget.organization?.id,
            //   'groupId': widget.group?.id,
            //   'name': nameController.text,
            //   'email': emailController.text,
            //   'password': passwordController.text,
            //   'uid': '',
            //   'token': '',
            //   'createdAt': DateTime.now(),
            // });
            // if (!mounted) return;
            // showMessage(context, 'スタッフを追加しました', true);
            // Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
