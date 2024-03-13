import 'package:fluent_ui/fluent_ui.dart';

class CustomIconTextButtonSm extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final Color labelColor;
  final Color backgroundColor;
  final Function()? onPressed;

  const CustomIconTextButtonSm({
    required this.icon,
    required this.labelText,
    required this.labelColor,
    required this.backgroundColor,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: ButtonState.all(backgroundColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 2),
            Text(
              labelText,
              style: TextStyle(
                color: labelColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
