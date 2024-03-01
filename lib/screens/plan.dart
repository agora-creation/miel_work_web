import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/organization.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/plan.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/screens/category.dart';
import 'package:miel_work_web/screens/plan_add.dart';
import 'package:miel_work_web/screens/plan_mod.dart';
import 'package:miel_work_web/services/plan.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_calendar.dart';
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
  PlanService planService = PlanService();

  @override
  Widget build(BuildContext context) {
    OrganizationGroupModel? group = widget.homeProvider.currentGroup;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomButtonSm(
              labelText: 'カテゴリ管理',
              labelColor: kBlackColor,
              backgroundColor: kCyanColor,
              onPressed: () => showBottomUpScreen(
                context,
                CategoryScreen(organization: widget.organization),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: planService.streamList(
                  organizationId: widget.organization?.id,
                  groupId: group?.id,
                ),
                builder: (context, snapshot) {
                  List<sfc.Appointment> appointments = [];
                  if (snapshot.hasData) {
                    for (DocumentSnapshot<Map<String, dynamic>> doc
                        in snapshot.data!.docs) {
                      PlanModel plan = PlanModel.fromSnapshot(doc);
                      appointments.add(sfc.Appointment(
                        id: plan.id,
                        resourceIds: plan.userIds,
                        subject: '[${plan.category}]${plan.subject}',
                        startTime: plan.startedAt,
                        endTime: plan.endedAt,
                        isAllDay: plan.allDay,
                        color: plan.color,
                      ));
                    }
                  }
                  return CustomCalendar(
                    dataSource: _DataSource(appointments),
                    onTap: (details) {
                      if (details.targetElement ==
                              sfc.CalendarElement.appointment ||
                          details.targetElement == sfc.CalendarElement.agenda) {
                        final sfc.Appointment appointmentDetails =
                            details.appointments![0];
                        showBottomUpScreen(
                          context,
                          PlanModScreen(
                            organization: widget.organization,
                            planId: '${appointmentDetails.id}',
                            groups: widget.homeProvider.groups,
                          ),
                        );
                      } else if (details.targetElement ==
                          sfc.CalendarElement.calendarCell) {
                        DateTime? date = details.date;
                        if (date == null) return;
                        showBottomUpScreen(
                          context,
                          PlanAddScreen(
                            organization: widget.organization,
                            group: group,
                            date: date,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
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
