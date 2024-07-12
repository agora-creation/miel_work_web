import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/widgets/animation_background.dart';

class LostScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const LostScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<LostScreen> createState() => _LostScreenState();
}

class _LostScreenState extends State<LostScreen> {
  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        AnimationBackground(),
      ],
    );
  }
}
