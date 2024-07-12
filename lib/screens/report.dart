import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/widgets/animation_background.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class ReportScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ReportScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AnimationBackground(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: sfc.SfCalendar(
              headerStyle: const sfc.CalendarHeaderStyle(
                backgroundColor: kWhiteColor,
              ),
              view: sfc.CalendarView.month,
              showNavigationArrow: true,
              showDatePickerButton: true,
              headerDateFormat: 'yyyy年MM月',
              monthCellBuilder: (context, details) {
                final Random random = Random();
                final Color defaultColor = Colors.white;
                return Container(
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 0.1, color: defaultColor),
                        left: BorderSide(width: 0.1, color: defaultColor),
                      ),
                      color: Colors.yellow.withOpacity(0.2)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              details.date.day.toString(),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'yaeh',
                        style: TextStyle(
                            fontSize: 15,
                            color: const Color.fromRGBO(42, 138, 148, 1),
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Text('gg')],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _DataSource extends sfc.CalendarDataSource {
  _DataSource(List<sfc.Appointment> source) {
    appointments = source;
  }
}
