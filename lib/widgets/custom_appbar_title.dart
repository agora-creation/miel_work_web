import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_icon_button_sm.dart';

class CustomAppbarTitle extends StatefulWidget {
  final OrganizationModel? organization;
  final HomeProvider homeProvider;
  final Function()? addOnPressed;
  final Function()? logoutOnPressed;

  const CustomAppbarTitle({
    required this.organization,
    required this.homeProvider,
    required this.addOnPressed,
    required this.logoutOnPressed,
    super.key,
  });

  @override
  State<CustomAppbarTitle> createState() => _CustomAppbarTitleState();
}

class _CustomAppbarTitleState extends State<CustomAppbarTitle> {
  void _init() async {
    widget.homeProvider.setGroups(organization: widget.organization);
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${widget.organization?.name}(${widget.homeProvider.currentGroup?.name ?? ''}) 管理画面',
            style: const TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              const Text('グループ選択:'),
              const SizedBox(width: 4),
              ComboBox(
                value: widget.homeProvider.currentGroup,
                items: widget.homeProvider.groups.map((group) {
                  return ComboBoxItem(
                    value: group,
                    child: Text(group.name),
                  );
                }).toList(),
                onChanged: (value) {
                  widget.homeProvider.currentGroupChange(value!);
                },
                placeholder: const Text('グループがありません'),
              ),
              const SizedBox(width: 4),
              CustomIconButtonSm(
                icon: FluentIcons.add,
                iconColor: kWhiteColor,
                backgroundColor: kBlueColor,
                onPressed: widget.addOnPressed,
              ),
              const SizedBox(width: 8),
              CustomButtonSm(
                labelText: '管理者太郎でログイン中',
                labelColor: kWhiteColor,
                backgroundColor: kGreyColor,
                onPressed: widget.logoutOnPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
