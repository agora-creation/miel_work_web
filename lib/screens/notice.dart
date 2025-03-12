import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/notice.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/notice_add.dart';
import 'package:miel_work_web/screens/notice_mod.dart';
import 'package:miel_work_web/services/notice.dart';
import 'package:miel_work_web/widgets/custom_icon_text_button.dart';
import 'package:miel_work_web/widgets/notice_list.dart';
import 'package:page_transition/page_transition.dart';

class NoticeScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const NoticeScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  NoticeService noticeService = NoticeService();
  DateTime? searchStart;
  DateTime? searchEnd;

  @override
  Widget build(BuildContext context) {
    String organizationName = widget.loginProvider.organization?.name ?? '';
    OrganizationGroupModel? group = widget.homeProvider.currentGroup;
    String groupName = group?.name ?? '';
    String searchText = '指定なし';
    if (searchStart != null && searchEnd != null) {
      searchText =
          '${dateText('yyyy/MM/dd', searchStart)}～${dateText('yyyy/MM/dd', searchEnd)}';
    }
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        title: const Text(
          'お知らせ',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.xmark,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    CustomIconTextButton(
                      label: '期間検索: $searchText',
                      labelColor: kWhiteColor,
                      backgroundColor: kSearchColor,
                      leftIcon: FontAwesomeIcons.magnifyingGlass,
                      onPressed: () async {
                        var selected = await showDataRangePickerDialog(
                          context: context,
                          startValue: searchStart,
                          endValue: searchEnd,
                        );
                        if (selected != null &&
                            selected.first != null &&
                            selected.last != null) {
                          var diff = selected.last!.difference(selected.first!);
                          int diffDays = diff.inDays;
                          if (diffDays > 31) {
                            if (!mounted) return;
                            showMessage(context, '1ヵ月以上の範囲が選択されています', false);
                            return;
                          }
                          searchStart = selected.first;
                          searchEnd = selected.last;
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(width: 4),
                    CustomIconTextButton(
                      label: 'タイトル検索: ',
                      labelColor: kWhiteColor,
                      backgroundColor: kSearchColor,
                      leftIcon: FontAwesomeIcons.magnifyingGlass,
                      onPressed: () {},
                    ),
                  ],
                ),
                CustomIconTextButton(
                  label: 'お知らせを追加',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  leftIcon: FontAwesomeIcons.plus,
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: NoticeAddScreen(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: noticeService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  searchStart: searchStart,
                  searchEnd: searchEnd,
                ),
                builder: (context, snapshot) {
                  List<NoticeModel> notices = [];
                  if (snapshot.hasData) {
                    notices = noticeService.generateList(
                      data: snapshot.data,
                      currentGroup: widget.homeProvider.currentGroup,
                    );
                  }
                  if (notices.isEmpty) {
                    return const Center(
                        child: Text(
                      'お知らせはありません',
                      style: TextStyle(fontSize: 24),
                    ));
                  }
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: kBorderColor),
                    ),
                    child: ListView.builder(
                      itemCount: notices.length,
                      itemBuilder: (context, index) {
                        NoticeModel notice = notices[index];
                        OrganizationGroupModel? noticeInGroup;
                        if (widget.homeProvider.groups.isNotEmpty) {
                          for (OrganizationGroupModel group
                              in widget.homeProvider.groups) {
                            if (group.id == notice.groupId) {
                              noticeInGroup = group;
                            }
                          }
                        }
                        return NoticeList(
                          notice: notice,
                          user: widget.loginProvider.user,
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: NoticeModScreen(
                                  loginProvider: widget.loginProvider,
                                  homeProvider: widget.homeProvider,
                                  notice: notice,
                                  noticeInGroup: noticeInGroup,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
