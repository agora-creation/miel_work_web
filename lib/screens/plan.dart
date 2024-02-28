import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/screens/plan_add.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class PlanScreen extends StatefulWidget {
  final HomeProvider homeProvider;
  final OrganizationModel? organization;

  const PlanScreen({
    required this.homeProvider,
    required this.organization,
    super.key,
  });

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  List<sfc.Appointment> appointments = [
    sfc.Appointment(
      id: 'a',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(minutes: 30)),
      subject: '来客',
      color: kBlueColor,
      isAllDay: false,
      notes: '',
      resourceIds: [],
    ),
    sfc.Appointment(
      id: 'b',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(minutes: 30)),
      subject: '打合せ',
      color: kRedColor,
      isAllDay: false,
      notes: '',
      resourceIds: [],
    ),
    sfc.Appointment(
      id: 'c',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(minutes: 30)),
      subject: '工事',
      color: kOrangeColor,
      isAllDay: false,
      notes: '',
      resourceIds: [],
    ),
    sfc.Appointment(
      id: 'd',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(minutes: 30)),
      subject: '工事',
      color: kOrangeColor,
      isAllDay: false,
      notes: '',
      resourceIds: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    String organizationName = widget.organization?.name ?? '';
    OrganizationGroupModel? group = widget.homeProvider.currentGroup;
    String groupName = group?.name ?? '';
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: sfc.SfCalendar(
          view: sfc.CalendarView.month,
          showNavigationArrow: true,
          showDatePickerButton: true,
          headerDateFormat: 'yyyy年MM月',
          onTap: (calendarTapDetails) {
            DateTime? tapDate = calendarTapDetails.date;
            if (tapDate == null) return;
            sfc.CalendarElement tapElement = calendarTapDetails.targetElement;
            if (tapElement == sfc.CalendarElement.calendarCell) {
              showBottomUpScreen(
                context,
                PlanAddScreen(
                  organization: widget.organization,
                  group: group,
                  date: tapDate,
                ),
              );
            } else if (tapElement == sfc.CalendarElement.appointment) {
              final sfc.Appointment appointment =
                  calendarTapDetails.appointments![0];
              print(appointment);
            }
          },
          onViewChanged: (viewChangedDetails) {
            // print(viewChangedDetails.visibleDates);
          },
          monthViewSettings: const sfc.MonthViewSettings(
            appointmentDisplayMode: sfc.MonthAppointmentDisplayMode.appointment,
            monthCellStyle: sfc.MonthCellStyle(
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
          cellBorderColor: kGrey600Color,
          dataSource: _DataSource(appointments),
        ),
      ),
    );
  }
}

class _DataSource extends sfc.CalendarDataSource {
  _DataSource(List<sfc.Appointment> source) {
    appointments = source;
  }
}
