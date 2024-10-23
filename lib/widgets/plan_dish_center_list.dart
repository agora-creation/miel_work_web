import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/plan_dish_center.dart';

class PlanDishCenterList extends StatelessWidget {
  final PlanDishCenterModel dishCenter;
  final Function()? onTap;

  const PlanDishCenterList({
    required this.dishCenter,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: kGreyColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          child: Text(
            '[${dishCenter.userName}]${dateText('HH:mm', dishCenter.startedAt)}〜${dateText('HH:mm', dishCenter.endedAt)}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'SourceHanSansJP-Bold',
            ),
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
