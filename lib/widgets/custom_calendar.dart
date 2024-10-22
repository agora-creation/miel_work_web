import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_web/common/style.dart';

class CustomCalendar extends StatelessWidget {
  final EventController<Object?> controller;
  final DateTime? initialMonth;
  final Function(List<CalendarEventData<Object?>>, DateTime)? onCellTap;

  const CustomCalendar({
    required this.controller,
    required this.initialMonth,
    required this.onCellTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: controller,
      child: MonthView(
        borderColor: kBorderColor,
        controller: controller,
        initialMonth: initialMonth,
        cellAspectRatio: 1,
        headerBuilder: MonthHeader.hidden,
        weekDayBuilder: (day) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              kWeeks[day],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'SourceHanSansJP-Bold',
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
        onCellTap: onCellTap,
        startDay: WeekDays.sunday,
        hideDaysNotInMonth: true,
      ),
    );
  }
}
