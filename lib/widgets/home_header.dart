import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/login.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_icon_button.dart';
import 'package:miel_work_web/widgets/custom_icon_text_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:miel_work_web/widgets/group_radio.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeHeader extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const HomeHeader({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  void initState() {
    widget.homeProvider.setGroups(
      organizationId: widget.loginProvider.organization?.id ?? 'error',
      group: widget.loginProvider.group,
      isAllGroup: widget.loginProvider.isAllGroup(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String organizationName = widget.loginProvider.organization?.name ?? '';
    String userName = widget.loginProvider.user?.name ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                organizationName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  CustomIconTextButton(
                    label:
                        widget.homeProvider.currentGroup?.name ?? 'グループの指定なし',
                    labelColor: kBlackColor,
                    backgroundColor: kWhiteColor,
                    rightIcon: FontAwesomeIcons.caretDown,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => GroupSelectDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                      ),
                    ),
                    disabled: !widget.loginProvider.isAllGroup(),
                  ),
                  const SizedBox(width: 4),
                  CustomIconButton(
                    icon: FontAwesomeIcons.plus,
                    iconColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AddGroupDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                      ),
                    ),
                    disabled: !widget.loginProvider.isAllGroup(),
                  ),
                  const SizedBox(width: 4),
                  CustomIconButton(
                    icon: FontAwesomeIcons.pen,
                    iconColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => ModGroupDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                        group: widget.homeProvider.currentGroup,
                      ),
                    ),
                    disabled: widget.loginProvider.user?.admin == false ||
                        widget.homeProvider.currentGroup == null,
                  ),
                  const SizedBox(width: 4),
                  CustomIconButton(
                    icon: FontAwesomeIcons.trash,
                    iconColor: kWhiteColor,
                    backgroundColor: kRedColor,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => DelGroupDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                        group: widget.homeProvider.currentGroup,
                      ),
                    ),
                    disabled: widget.loginProvider.user?.admin == false ||
                        widget.homeProvider.currentGroup == null,
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              CustomButton(
                type: ButtonSizeType.sm,
                label: 'マニュアル',
                labelColor: kBlackColor,
                backgroundColor: kRed200Color,
                onPressed: () async {
                  Uri url =
                      Uri.parse('https://agora-c.com/miel-work/manual_web.pdf');
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
              ),
              const SizedBox(width: 4),
              CustomButton(
                type: ButtonSizeType.sm,
                label: '$userNameでログイン中',
                labelColor: kBlackColor,
                backgroundColor: kWhiteColor,
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => CustomAlertDialog(
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          '本当にログアウトしますか？',
                          style: TextStyle(
                            color: kRedColor,
                            fontSize: 16,
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
                        label: 'ログアウト',
                        labelColor: kWhiteColor,
                        backgroundColor: kRedColor,
                        onPressed: () async {
                          await widget.loginProvider.logout();
                          if (!mounted) return;
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              type: PageTransitionType.topToBottom,
                              child: const LoginScreen(),
                            ),
                          );
                        },
                      ),
                    ],
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

class GroupSelectDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const GroupSelectDialog({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<GroupSelectDialog> createState() => _GroupSelectDialogState();
}

class _GroupSelectDialogState extends State<GroupSelectDialog> {
  @override
  Widget build(BuildContext context) {
    List<Widget> groupChildren = [];
    if (widget.homeProvider.groups.isNotEmpty) {
      groupChildren.add(GroupRadio(
        group: null,
        value: widget.homeProvider.currentGroup,
        onChanged: (value) {
          widget.homeProvider.currentGroupChange(value);
          Navigator.pop(context);
        },
      ));
      for (OrganizationGroupModel group in widget.homeProvider.groups) {
        groupChildren.add(GroupRadio(
          group: group,
          value: widget.homeProvider.currentGroup,
          onChanged: (value) {
            widget.homeProvider.currentGroupChange(value);
            Navigator.pop(context);
          },
        ));
      }
    }
    return CustomAlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(border: Border.all(color: kGrey600Color)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: groupChildren,
          ),
        ),
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
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          FormLabel(
            'グループ名',
            child: CustomTextField(
              controller: nameController,
              textInputType: TextInputType.name,
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
          label: '追加する',
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

class ModGroupDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final OrganizationGroupModel? group;

  const ModGroupDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.group,
    super.key,
  });

  @override
  State<ModGroupDialog> createState() => _ModGroupDialogState();
}

class _ModGroupDialogState extends State<ModGroupDialog> {
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.group?.name ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          FormLabel(
            'グループ名',
            child: CustomTextField(
              controller: nameController,
              textInputType: TextInputType.name,
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
          label: '保存する',
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

class DelGroupDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final OrganizationGroupModel? group;

  const DelGroupDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.group,
    super.key,
  });

  @override
  State<DelGroupDialog> createState() => _DelGroupDialogState();
}

class _DelGroupDialogState extends State<DelGroupDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          const Text(
            '本当に削除しますか？',
            style: TextStyle(color: kRedColor),
          ),
          const SizedBox(height: 8),
          FormLabel(
            'グループ名',
            child: FormValue(widget.group?.name ?? ''),
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
          label: '削除する',
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
