import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/request_overtime.dart';

class RequestOvertimeList extends StatelessWidget {
  final RequestOvertimeModel overtime;
  final Function()? onTap;

  const RequestOvertimeList({
    required this.overtime,
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
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  overtime.companyName,
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  '店舗責任者名: ${overtime.companyUserName}',
                  style: const TextStyle(
                    color: kGreyColor,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '申請日時: ${dateText('yyyy/MM/dd HH:mm', overtime.createdAt)}',
                  style: const TextStyle(
                    color: kGreyColor,
                    fontSize: 14,
                  ),
                ),
                overtime.approval == 1
                    ? Text(
                        '承認日時: ${dateText('yyyy/MM/dd HH:mm', overtime.approvedAt)}',
                        style: const TextStyle(
                          color: kRedColor,
                          fontSize: 14,
                        ),
                      )
                    : Container(),
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
