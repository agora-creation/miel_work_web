import 'package:flutter/material.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization_group.dart';

class GroupRadio extends StatelessWidget {
  final OrganizationGroupModel? group;
  final OrganizationGroupModel? value;
  final void Function(OrganizationGroupModel?)? onChanged;

  const GroupRadio({
    required this.group,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      child: RadioListTile<OrganizationGroupModel?>(
        title: group != null
            ? Text(
                group?.name ?? '',
                style: const TextStyle(fontSize: 20),
              )
            : const Text(
                'グループの指定なし',
                style: TextStyle(
                  color: kGreyColor,
                  fontSize: 20,
                ),
              ),
        value: group,
        groupValue: value,
        onChanged: onChanged,
      ),
    );
  }
}
