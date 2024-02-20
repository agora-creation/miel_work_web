import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';

class CustomAppbarTitle extends StatefulWidget {
  final OrganizationModel? organization;
  final HomeProvider homeProvider;
  final Function()? addOnPressed;

  const CustomAppbarTitle({
    required this.organization,
    required this.homeProvider,
    required this.addOnPressed,
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
        children: [
          Text(
            widget.organization?.name ?? '',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 8),
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
          CustomButtonSm(
            labelText: 'グループを追加',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: widget.addOnPressed,
          ),
        ],
      ),
    );
  }
}
