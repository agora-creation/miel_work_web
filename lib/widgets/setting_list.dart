import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/style.dart';

class SettingList extends StatelessWidget {
  final String label;
  final String value;
  final Function()? onTap;
  final bool isFirst;

  const SettingList({
    required this.label,
    required this.value,
    this.onTap,
    this.isFirst = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: isFirst
              ? const Border.symmetric(
                  horizontal: BorderSide(color: kGreyColor),
                )
              : const Border(bottom: BorderSide(color: kGreyColor)),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: kGreyColor,
                    fontSize: 14,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const FaIcon(
              FontAwesomeIcons.pen,
              color: kGrey600Color,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
