import 'package:flutter/material.dart';
import 'package:miel_work_web/common/style.dart';

class PlanWorkList extends StatelessWidget {
  final String label;

  const PlanWorkList(
    this.label, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        color: kLightBlueColor.withOpacity(0.2),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'SourceHanSansJP-Bold',
          ),
        ),
      ),
    );
  }
}
