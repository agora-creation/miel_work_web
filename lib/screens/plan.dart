import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/category.dart';
import 'package:miel_work_web/screens/plan_add.dart';
import 'package:miel_work_web/screens/plan_mod.dart';
import 'package:miel_work_web/services/plan.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class PlanScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const PlanScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  PlanService planService = PlanService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomButtonSm(
              labelText: 'カテゴリ管理',
              labelColor: kWhiteColor,
              backgroundColor: kCyanColor,
              onPressed: () => showBottomUpScreen(
                context,
                CategoryScreen(
                  loginProvider: widget.loginProvider,
                  homeProvider: widget.homeProvider,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: planService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  groupId: widget.homeProvider.currentGroup?.id,
                ),
                builder: (context, snapshot) {
                  List<sfc.Appointment> appointments = [];
                  if (snapshot.hasData) {
                    appointments = planService.generateList(
                      data: snapshot.data,
                    );
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
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            planId: '${appointmentDetails.id}',
                          ),
                        );
                      } else if (details.targetElement ==
                          sfc.CalendarElement.calendarCell) {
                        DateTime? date = details.date;
                        if (date == null) return;
                        showBottomUpScreen(
                          context,
                          PlanAddScreen(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
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
