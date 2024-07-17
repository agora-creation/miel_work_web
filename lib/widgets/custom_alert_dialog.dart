import 'package:flutter/material.dart';
import 'package:miel_work_web/common/style.dart';

class CustomAlertDialog extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final Widget? content;
  final List<Widget>? actions;

  const CustomAlertDialog({
    this.contentPadding,
    required this.content,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: contentPadding,
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      content: content,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: actions,
    );
  }
}
