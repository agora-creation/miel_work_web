import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/request_const.dart';

class RequestConstList extends StatelessWidget {
  final RequestConstModel requestConst;
  final Function()? onTap;

  const RequestConstList({
    required this.requestConst,
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
                  requestConst.companyName,
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  '店舗責任者名: ${requestConst.companyUserName}',
                  style: const TextStyle(
                    color: kGreyColor,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '申請日時: ${dateText('yyyy/MM/dd HH:mm', requestConst.createdAt)}',
                  style: const TextStyle(
                    color: kGreyColor,
                    fontSize: 14,
                  ),
                ),
                requestConst.approval == 1
                    ? Text(
                        '承認日時: ${dateText('yyyy/MM/dd HH:mm', requestConst.approvedAt)}',
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
