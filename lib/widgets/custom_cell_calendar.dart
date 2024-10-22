import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';

class CustomCellCalendar extends StatelessWidget {
  final CellCalendarPageController? controller;
  final List<CalendarEvent> events;
  final Function(DateTime)? onCellTapped;

  const CustomCellCalendar({
    required this.controller,
    required this.events,
    required this.onCellTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CellCalendar(
      cellCalendarPageController: controller,
      events: events,
      onCellTapped: onCellTapped,
      daysOfTheWeekBuilder: (dayIndex) {
        final labels = ['日', '月', '火', '水', '木', '金', '土'];
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            labels[dayIndex],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'SourceHanSansJP-Bold',
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
      monthYearLabelBuilder: (datetime) {
        return Container();
      },
      dateTextStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceHanSansJP-Bold',
      ),
    );
  }
}
