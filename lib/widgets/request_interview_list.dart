import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/request_interview.dart';

class RequestInterviewList extends StatelessWidget {
  final RequestInterviewModel interview;
  final Function()? onTap;

  const RequestInterviewList({
    required this.interview,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: kBorderColor)),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  interview.companyName,
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  '申込担当者名: ${interview.companyUserName}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  '申込日時: ${dateText('yyyy/MM/dd HH:mm', interview.createdAt)}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const FaIcon(
              FontAwesomeIcons.chevronRight,
              color: kDisabledColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
