import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/plan_add.dart';
import 'package:miel_work_web/screens/plan_mod.dart';
import 'package:miel_work_web/services/plan.dart';
import 'package:miel_work_web/widgets/custom_calendar_timeline.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class PlanTimelineScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final DateTime date;

  const PlanTimelineScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.date,
    super.key,
  });

  @override
  State<PlanTimelineScreen> createState() => _PlanTimelineScreenState();
}

class _PlanTimelineScreenState extends State<PlanTimelineScreen> {
  PlanService planService = PlanService();
  List<String> searchCategories = [];

  void _searchCategoriesChange() async {
    searchCategories = await getPrefsList('categories') ?? [];
    setState(() {});
  }

  void _calendarTap(sfc.CalendarTapDetails details) {
    sfc.CalendarElement element = details.targetElement;
    switch (element) {
      case sfc.CalendarElement.appointment:
      case sfc.CalendarElement.agenda:
        sfc.Appointment appointmentDetails = details.appointments![0];
        Navigator.push(
          context,
          FluentPageRoute(
            builder: (context) => PlanModScreen(
              loginProvider: widget.loginProvider,
              homeProvider: widget.homeProvider,
              planId: '${appointmentDetails.id}',
            ),
          ),
        );
        break;
      case sfc.CalendarElement.calendarCell:
        Navigator.push(
          context,
          FluentPageRoute(
            builder: (context) => PlanAddScreen(
              loginProvider: widget.loginProvider,
              homeProvider: widget.homeProvider,
              date: details.date ?? DateTime.now(),
            ),
          ),
        );
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _searchCategoriesChange();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      header: Container(
        decoration: kHeaderDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(FluentIcons.chevron_left),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                dateText('yyyy年MM月dd日(E)', widget.date),
                style: const TextStyle(fontSize: 16),
              ),
              Container(),
            ],
          ),
        ),
      ),
      content: Container(
        color: kWhiteColor,
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: planService.streamList(
            organizationId: widget.loginProvider.organization?.id,
            groupId: widget.homeProvider.currentGroup?.id,
            categories: searchCategories,
          ),
          builder: (context, snapshot) {
            List<sfc.Appointment> appointments = [];
            if (snapshot.hasData) {
              appointments = planService.generateListAppointment(
                data: snapshot.data,
                date: widget.date,
              );
            }
            return CustomCalendarTimeline(
              initialDisplayDate: widget.date,
              dataSource: _DataSource(appointments),
              onTap: _calendarTap,
            );
          },
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
