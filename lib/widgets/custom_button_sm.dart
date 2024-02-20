import 'package:fluent_ui/fluent_ui.dart';

class CustomButtonSm extends StatelessWidget {
  final String labelText;
  final Color labelColor;
  final Color backgroundColor;
  final Function()? onPressed;

  const CustomButtonSm({
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
      style: ButtonStyle(backgroundColor: ButtonState.all(backgroundColor)),
      child: Text(
        labelText,
        style: TextStyle(
          color: labelColor,
          fontSize: 14,
        ),
      ),
    );
  }
}
