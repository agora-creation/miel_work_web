import 'package:flutter/material.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/category.dart';

class CategoryCheckboxList extends StatelessWidget {
  final CategoryModel category;
  final bool value;
  final Function(bool?)? onChanged;

  const CategoryCheckboxList({
    required this.category,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: category.color,
        border: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      child: CheckboxListTile(
        title: Text(
          category.name,
          style: const TextStyle(
            color: kWhiteColor,
            fontSize: 18,
          ),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
