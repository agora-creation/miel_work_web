import 'package:flutter/material.dart';
import 'package:miel_work_web/common/style.dart';

class CustomCheckbox extends StatelessWidget {
  final String label;
  final String? subLabel;
  final bool value;
  final Function(bool?)? onChanged;
  final Widget child;

  const CustomCheckbox({
    required this.label,
    this.subLabel,
    required this.value,
    required this.onChanged,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: kDisabledColor),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: CheckboxListTile(
              title: Text(label),
              subtitle: subLabel != null ? Text(subLabel!) : null,
              value: value,
              onChanged: onChanged,
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          SizedBox(
            width: 100,
            child: child,
          ),
        ],
      ),
    );
  }
}
