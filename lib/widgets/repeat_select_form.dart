import 'package:flutter/material.dart';

class RepeatSelectForm extends StatelessWidget {
  final bool repeat;
  final Function(bool?) repeatOnChanged;
  final String interval;
  final Function(String) intervalOnChanged;
  final TextEditingController everyController;
  final List<String> weeks;
  final Function(String) weeksOnChanged;

  const RepeatSelectForm({
    required this.repeat,
    required this.repeatOnChanged,
    required this.interval,
    required this.intervalOnChanged,
    required this.everyController,
    required this.weeks,
    required this.weeksOnChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<bool>(
          isExpanded: true,
          value: repeat,
          items: const [
            DropdownMenuItem(
              value: false,
              child: Text('繰り返さない'),
            ),
            DropdownMenuItem(
              value: true,
              child: Text('繰り返す'),
            ),
          ],
          onChanged: repeatOnChanged,
        ),
        const SizedBox(height: 4),
        // repeat
        //     ? Container(
        //         decoration: BoxDecoration(
        //           border: Border.all(color: kGrey300Color),
        //         ),
        //         padding: const EdgeInsets.all(8),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Row(
        //               children: kRepeatIntervals.map((e) {
        //                 return Padding(
        //                   padding: const EdgeInsets.only(
        //                     right: 4,
        //                   ),
        //                   child: ToggleButton(
        //                     checked: e == interval,
        //                     onChanged: (value) {
        //                       intervalOnChanged(e);
        //                     },
        //                     child: Text(e),
        //                   ),
        //                 );
        //               }).toList(),
        //             ),
        //             const SizedBox(height: 4),
        //             interval == kRepeatIntervals[0]
        //                 ? SizedBox(
        //                     width: 100,
        //                     child: TextBox(
        //                       controller: everyController,
        //                       keyboardType: TextInputType.number,
        //                       suffix: const Text('日ごと'),
        //                     ),
        //                   )
        //                 : Container(),
        //             interval == kRepeatIntervals[1]
        //                 ? SizedBox(
        //                     width: 100,
        //                     child: TextBox(
        //                       controller: everyController,
        //                       keyboardType: TextInputType.number,
        //                       suffix: const Text('週間ごと'),
        //                     ),
        //                   )
        //                 : Container(),
        //             interval == kRepeatIntervals[2]
        //                 ? SizedBox(
        //                     width: 100,
        //                     child: TextBox(
        //                       controller: everyController,
        //                       keyboardType: TextInputType.number,
        //                       suffix: const Text('ヶ月ごと'),
        //                     ),
        //                   )
        //                 : Container(),
        //             const SizedBox(height: 4),
        //             interval == kRepeatIntervals[1]
        //                 ? Row(
        //                     children: kWeeks.map((e) {
        //                       return Padding(
        //                         padding: const EdgeInsets.only(
        //                           right: 16,
        //                         ),
        //                         child: Checkbox(
        //                           checked: weeks.contains(e),
        //                           content: Text(e),
        //                           onChanged: (value) {
        //                             weeksOnChanged(e);
        //                           },
        //                         ),
        //                       );
        //                     }).toList(),
        //                   )
        //                 : Container(),
        //           ],
        //         ),
        //       )
        //     : Container(),
      ],
    );
  }
}
