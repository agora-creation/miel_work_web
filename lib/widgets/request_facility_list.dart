import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/request_facility.dart';
import 'package:miel_work_web/models/user.dart';

class RequestFacilityList extends StatelessWidget {
  final RequestFacilityModel facility;
  final UserModel? user;
  final Function()? onTap;

  const RequestFacilityList({
    required this.facility,
    required this.user,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool commentNotRead = true;
    if (facility.comments.isNotEmpty) {
      for (final comment in facility.comments) {
        if (comment.readUserIds.contains(user?.id)) {
          commentNotRead = false;
        }
      }
    }
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
                  facility.companyName,
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  '店舗責任者名: ${facility.companyUserName}',
                  style: const TextStyle(
                    color: kGreyColor,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '申込日時: ${dateText('yyyy/MM/dd HH:mm', facility.createdAt)}',
                  style: const TextStyle(
                    color: kGreyColor,
                    fontSize: 14,
                  ),
                ),
                facility.approval == 1
                    ? Text(
                        '承認日時: ${dateText('yyyy/MM/dd HH:mm', facility.approvedAt)}',
                        style: const TextStyle(
                          color: kRedColor,
                          fontSize: 14,
                        ),
                      )
                    : Container(),
                commentNotRead && facility.comments.isNotEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Chip(
                          label: Text(
                            '未読コメントあり',
                            style: TextStyle(
                              color: kLightGreenColor,
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor: kWhiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          side: BorderSide(color: kLightGreenColor),
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
