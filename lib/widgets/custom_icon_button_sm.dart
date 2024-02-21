import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';

class CustomIconButtonSm extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Function()? onPressed;

  const CustomIconButtonSm({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: kWhiteColor,
      ),
      style: ButtonStyle(
        backgroundColor: ButtonState.all(kBlueColor),
        padding: ButtonState.all(const EdgeInsets.all(12)),
      ),
      onPressed: onPressed,
    );
  }
}
