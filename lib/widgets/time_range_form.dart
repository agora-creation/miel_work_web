import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/style.dart';

class TimeRangeForm extends StatelessWidget {
  final String startedTime;
  final Function() startedOnTap;
  final String endedTime;
  final Function() endedOnTap;

  const TimeRangeForm({
    required this.startedTime,
    required this.startedOnTap,
    required this.endedTime,
    required this.endedOnTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: kBorderColor)),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '時間部分をタップすると、時間選択ダイアログが画面下部に表示されます。',
            style: TextStyle(
              color: kGreyColor,
              fontSize: 12,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: startedOnTap,
                  child: Text(
                    startedTime,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const FaIcon(
                  FontAwesomeIcons.chevronRight,
                  color: kDisabledColor,
                  size: 24,
                ),
                GestureDetector(
                  onTap: endedOnTap,
                  child: Text(
                    endedTime,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
