import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/chat_message.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/apply.dart';
import 'package:miel_work_web/screens/chat.dart';
import 'package:miel_work_web/screens/loan.dart';
import 'package:miel_work_web/screens/lost.dart';
import 'package:miel_work_web/screens/notice.dart';
import 'package:miel_work_web/screens/plan.dart';
import 'package:miel_work_web/screens/problem.dart';
import 'package:miel_work_web/screens/report.dart';
import 'package:miel_work_web/screens/user.dart';
import 'package:miel_work_web/screens/work.dart';
import 'package:miel_work_web/services/apply.dart';
import 'package:miel_work_web/services/chat_message.dart';
import 'package:miel_work_web/services/loan.dart';
import 'package:miel_work_web/services/lost.dart';
import 'package:miel_work_web/services/notice.dart';
import 'package:miel_work_web/services/problem.dart';
import 'package:miel_work_web/widgets/animation_background.dart';
import 'package:miel_work_web/widgets/home_header.dart';
import 'package:miel_work_web/widgets/home_icon_card.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NoticeService noticeService = NoticeService();
  ChatMessageService messageService = ChatMessageService();
  ProblemService problemService = ProblemService();
  ApplyService applyService = ApplyService();
  LostService lostService = LostService();
  LoanService loanService = LoanService();

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          const AnimationBackground(),
          SafeArea(
            child: Column(
              children: [
                HomeHeader(
                  loginProvider: loginProvider,
                  homeProvider: homeProvider,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: kHomeGridDelegate,
                      children: [
                        HomeIconCard(
                          icon: FontAwesomeIcons.solidCalendar,
                          label: 'スケジュール',
                          color: kBlackColor,
                          backgroundColor: kWhiteColor,
                          onTap: () => showBottomUpScreen(
                            context,
                            PlanScreen(
                              loginProvider: loginProvider,
                              homeProvider: homeProvider,
                            ),
                          ),
                        ),
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: noticeService.streamList(
                            organizationId: loginProvider.organization?.id,
                            searchStart: null,
                            searchEnd: null,
                          ),
                          builder: (context, snapshot) {
                            bool alert = false;
                            if (snapshot.hasData) {
                              alert = noticeService.checkAlert(
                                data: snapshot.data,
                                currentGroup: homeProvider.currentGroup,
                                user: loginProvider.user,
                              );
                            }
                            return HomeIconCard(
                              icon: FontAwesomeIcons.solidBell,
                              label: 'お知らせ',
                              color: kBlackColor,
                              backgroundColor: kWhiteColor,
                              alert: alert,
                              onTap: () => showBottomUpScreen(
                                context,
                                NoticeScreen(
                                  loginProvider: loginProvider,
                                  homeProvider: homeProvider,
                                ),
                              ),
                            );
                          },
                        ),
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: messageService.streamListUnread(
                            organizationId: loginProvider.organization?.id,
                          ),
                          builder: (context, snapshot) {
                            bool alert = false;
                            if (snapshot.hasData) {
                              List<ChatMessageModel> messages =
                                  messageService.generateListUnread(
                                data: snapshot.data,
                                currentGroup: homeProvider.currentGroup,
                                loginUser: loginProvider.user,
                              );
                              if (messages.isNotEmpty) {
                                alert = true;
                              }
                            }
                            return HomeIconCard(
                              icon: FontAwesomeIcons.solidComments,
                              label: 'チャット',
                              color: kBlackColor,
                              backgroundColor: kWhiteColor,
                              alert: alert,
                              onTap: () => showBottomUpScreen(
                                context,
                                ChatScreen(
                                  loginProvider: loginProvider,
                                  homeProvider: homeProvider,
                                ),
                              ),
                            );
                          },
                        ),
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: problemService.streamList(
                            organizationId: loginProvider.organization?.id,
                            searchStart: null,
                            searchEnd: null,
                            processed: false,
                          ),
                          builder: (context, snapshot) {
                            bool alert = false;
                            if (snapshot.hasData) {
                              alert = problemService.checkAlert(
                                data: snapshot.data,
                                user: loginProvider.user,
                              );
                            }
                            return HomeIconCard(
                              icon: FontAwesomeIcons.triangleExclamation,
                              label: 'クレーム／要望',
                              color: kBlackColor,
                              backgroundColor: kWhiteColor,
                              alert: alert,
                              onTap: () => showBottomUpScreen(
                                context,
                                ProblemScreen(
                                  loginProvider: loginProvider,
                                  homeProvider: homeProvider,
                                ),
                              ),
                            );
                          },
                        ),
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: applyService.streamList(
                            organizationId: loginProvider.organization?.id,
                            searchStart: null,
                            searchEnd: null,
                            approval: [0],
                          ),
                          builder: (context, snapshot) {
                            bool alert = false;
                            if (snapshot.hasData) {
                              alert = applyService.checkAlert(
                                data: snapshot.data,
                              );
                            }
                            return HomeIconCard(
                              icon: FontAwesomeIcons.filePen,
                              label: '各種申請',
                              color: kBlackColor,
                              backgroundColor: kWhiteColor,
                              alert: alert,
                              alertMessage: '承認待ちあり',
                              onTap: () => showBottomUpScreen(
                                context,
                                ApplyScreen(
                                  loginProvider: loginProvider,
                                  homeProvider: homeProvider,
                                ),
                              ),
                            );
                          },
                        ),
                        HomeIconCard(
                          icon: FontAwesomeIcons.businessTime,
                          label: '勤怠打刻',
                          color: kBlackColor,
                          backgroundColor: kWhiteColor,
                          onTap: () => showBottomUpScreen(
                            context,
                            WorkScreen(
                              loginProvider: loginProvider,
                              homeProvider: homeProvider,
                            ),
                          ),
                        ),
                        HomeIconCard(
                          icon: FontAwesomeIcons.clipboardCheck,
                          label: '業務日報',
                          color: kBlackColor,
                          backgroundColor: kWhiteColor,
                          onTap: () => showBottomUpScreen(
                            context,
                            ReportScreen(
                              loginProvider: loginProvider,
                              homeProvider: homeProvider,
                            ),
                          ),
                        ),
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: lostService.streamList(
                            organizationId: loginProvider.organization?.id,
                            searchStart: null,
                            searchEnd: null,
                            searchStatus: [0],
                          ),
                          builder: (context, snapshot) {
                            bool alert = false;
                            if (snapshot.hasData) {
                              alert = lostService.checkAlert(
                                data: snapshot.data,
                              );
                            }
                            return HomeIconCard(
                              icon: FontAwesomeIcons.personCircleQuestion,
                              label: '落とし物',
                              color: kBlackColor,
                              backgroundColor: kWhiteColor,
                              alert: alert,
                              alertMessage: '保管中',
                              onTap: () => showBottomUpScreen(
                                context,
                                LostScreen(
                                  loginProvider: loginProvider,
                                  homeProvider: homeProvider,
                                ),
                              ),
                            );
                          },
                        ),
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: loanService.streamList(
                            organizationId: loginProvider.organization?.id,
                            searchStart: null,
                            searchEnd: null,
                            searchStatus: [0],
                          ),
                          builder: (context, snapshot) {
                            bool alert = false;
                            if (snapshot.hasData) {
                              alert = loanService.checkAlert(
                                data: snapshot.data,
                              );
                            }
                            return HomeIconCard(
                              icon: FontAwesomeIcons.rightLeft,
                              label: '貸出／返却',
                              color: kBlackColor,
                              backgroundColor: kWhiteColor,
                              alert: alert,
                              alertMessage: '貸出中',
                              onTap: () => showBottomUpScreen(
                                context,
                                LoanScreen(
                                  loginProvider: loginProvider,
                                  homeProvider: homeProvider,
                                ),
                              ),
                            );
                          },
                        ),
                        HomeIconCard(
                          icon: FontAwesomeIcons.bolt,
                          label: 'メーター検針',
                          color: kBlackColor,
                          backgroundColor: kWhiteColor,
                          onTap: () async {
                            Uri url =
                                Uri.parse('https://hirome.co.jp/meter/system/');
                            if (!await launchUrl(url)) {
                              throw Exception('Could not launch $url');
                            }
                          },
                        ),
                        HomeIconCard(
                          icon: FontAwesomeIcons.users,
                          label: 'スタッフ一覧',
                          color: kWhiteColor,
                          backgroundColor: kDisabledColor,
                          onTap: () => showBottomUpScreen(
                            context,
                            UserScreen(
                              loginProvider: loginProvider,
                              homeProvider: homeProvider,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
