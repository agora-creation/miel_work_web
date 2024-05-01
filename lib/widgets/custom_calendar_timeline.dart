import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class CustomCalendarTimeline extends StatelessWidget {
  final DateTime initialDisplayDate;
  final sfc.CalendarDataSource<Object?>? dataSource;
  final Function(sfc.CalendarTapDetails)? onTap;

  const CustomCalendarTimeline({
    required this.initialDisplayDate,
    required this.dataSource,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return sfc.SfCalendar(
      headerHeight: 0,
      viewHeaderHeight: 0,
      viewNavigationMode: sfc.ViewNavigationMode.none,
      initialDisplayDate: initialDisplayDate,
      dataSource: dataSource,
      view: sfc.CalendarView.day,
      onTap: onTap,
      cellBorderColor: kGrey600Color,
      appointmentTextStyle: TextStyle(
        color: kWhiteColor,
        fontSize: 10,
      ),
    );
  }
}
