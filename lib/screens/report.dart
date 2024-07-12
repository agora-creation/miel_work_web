import 'package:fluent_ui/fluent_ui.dart';
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
            child: sfc.SfCalendar(),
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
