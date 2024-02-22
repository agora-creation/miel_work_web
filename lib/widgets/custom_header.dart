import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/draft.dart';
import 'package:miel_work_web/screens/meter.dart';
import 'package:miel_work_web/screens/user_setting.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_icon_button_sm.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';

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
                onPressed: () => showBottomUpScreen(
                  context,
                  const MeterScreen(),
                ),
              ),
              const SizedBox(width: 4),
              CustomButtonSm(
                labelText: '稟議書申請',
                labelColor: kBlackColor,
                backgroundColor: kOrangeColor,
                onPressed: () => showBottomUpScreen(
                  context,
                  const DraftScreen(),
                ),
              ),
              const SizedBox(width: 4),
              CustomButtonSm(
                labelText: '$userNameでログイン中',
                labelColor: kWhiteColor,
                backgroundColor: kGreyColor,
                onPressed: () => showBottomUpScreen(
                  context,
                  UserSettingScreen(loginProvider: widget.loginProvider),
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
        'グループを追加する',
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
