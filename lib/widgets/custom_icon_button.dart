import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/style.dart';

class CustomIconButton extends StatelessWidget {
  final IconData? icon;
  final Color iconColor;
  final Color backgroundColor;
  final Function()? onPressed;
  final bool disabled;

  const CustomIconButton({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.onPressed,
    this.disabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: disabled ? kDisabledColor : backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: FaIcon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
