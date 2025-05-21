import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/lost.dart';
import 'package:miel_work_web/models/user.dart';

class LostCard extends StatelessWidget {
  final LostModel lost;
  final UserModel? user;
  final Function()? onTap;

  const LostCard({
    required this.lost,
    required this.user,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool commentNotRead = true;
    if (lost.comments.isNotEmpty) {
      for (final comment in lost.comments) {
        if (comment.readUserIds.contains(user?.id)) {
          commentNotRead = false;
        }
      }
    }
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Card(
            color: kWhiteColor,
            elevation: 8,
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: lost.itemImage != ''
                            ? Image.network(
                                lost.itemImage,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: kGreyColor.withOpacity(0.3),
                                width: double.infinity,
                                height: 150,
                                child: const Center(
                                  child: Text('写真なし'),
                                ),
                              ),
                      ),
                      Table(
                        border: TableBorder.all(color: kBorderColor),
                        columnWidths: const {
                          0: IntrinsicColumnWidth(),
                          1: FlexColumnWidth(2),
                        },
                        children: [
                          TableRow(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(4),
                                child: Text('落とし物No'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  lost.itemNumber,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(4),
                                child: Text('品名'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  lost.itemName,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(4),
                                child: Text('発見日'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  dateText('yyyy/MM/dd', lost.discoveryAt),
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(4),
                                child: Text('発見場所'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  lost.discoveryPlace,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(4),
                                child: Text('発見者'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  lost.discoveryUser,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(4),
                                child: Text('備考'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  lost.remarks,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          commentNotRead
              ? const Positioned(
                  top: 8,
                  right: 8,
                  child: Chip(
                    label: Text(
                      '未読コメントあり',
                      style: TextStyle(
                        color: kLightGreenColor,
                        fontSize: 10,
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
    );
  }
}
