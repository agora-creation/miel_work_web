import 'package:flutter/material.dart';
import 'package:miel_work_web/common/style.dart';

enum ButtonSizeType { sm, lg }

class CustomButton extends StatelessWidget {
  final ButtonSizeType type;
  final String label;
  final Color labelColor;
  final Color backgroundColor;
  final Function()? onPressed;
  final bool disabled;

  const CustomButton({
    required this.type,
    required this.label,
    required this.labelColor,
    required this.backgroundColor,
    this.onPressed,
    this.disabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (type == ButtonSizeType.lg) {
      return SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: disabled ? onPressed : null,
          style: TextButton.styleFrom(
            backgroundColor: disabled ? backgroundColor : kGreyColor,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.all(24),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'SourceHanSansJP-Bold',
            ),
          ),
        ),
      );
    } else {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.all(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 18,
          ),
        ),
      );
    }
  }
}
