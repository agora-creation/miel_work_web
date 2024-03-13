import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';

class DatetimeRangeForm extends StatelessWidget {
  final DateTime startedAt;
  final Function() startedOnTap;
  final DateTime endedAt;
  final Function() endedOnTap;
  final bool allDay;
  final Function(bool?) allDayOnChanged;

  const DatetimeRangeForm({
    required this.startedAt,
    required this.startedOnTap,
    required this.endedAt,
    required this.endedOnTap,
    required this.allDay,
    required this.allDayOnChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: kGreyColor)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: startedOnTap,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateText('yyyy年MM月dd日(E)', startedAt),
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        dateText('HH:mm', startedAt),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  FluentIcons.chevron_right,
                  color: kGrey600Color,
                  size: 24,
                ),
                GestureDetector(
                  onTap: endedOnTap,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateText('yyyy年MM月dd日(E)', endedAt),
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        dateText('HH:mm', endedAt),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: kGreyColor)),
            ),
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            child: Checkbox(
              checked: allDay,
              onChanged: allDayOnChanged,
              content: const Text('終日'),
            ),
          ),
        ],
      ),
    );
  }
}
