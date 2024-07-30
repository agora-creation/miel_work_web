import 'package:flutter/material.dart';
import 'package:miel_work_web/common/style.dart';

class CheckboxList extends StatelessWidget {
  final bool? value;
  final Function(bool?)? onChanged;
  final String label;

  const CheckboxList({
    this.value,
    this.onChanged,
    this.label = '',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Text(label),
      ),
    );
  }
}
