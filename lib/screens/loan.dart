// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:miel_work_web/common/functions.dart';
// import 'package:miel_work_web/common/style.dart';
// import 'package:miel_work_web/models/loan.dart';
// import 'package:miel_work_web/providers/home.dart';
// import 'package:miel_work_web/providers/login.dart';
// import 'package:miel_work_web/screens/loan_add.dart';
// import 'package:miel_work_web/screens/loan_history.dart';
// import 'package:miel_work_web/screens/loan_mod.dart';
// import 'package:miel_work_web/services/loan.dart';
// import 'package:miel_work_web/widgets/animation_background.dart';
// import 'package:miel_work_web/widgets/custom_button_sm.dart';
// import 'package:miel_work_web/widgets/loan_card.dart';
//
// class LoanScreen extends StatefulWidget {
//   final LoginProvider loginProvider;
//   final HomeProvider homeProvider;
//
//   const LoanScreen({
//     required this.loginProvider,
//     required this.homeProvider,
//     super.key,
//   });
//
//   @override
//   State<LoanScreen> createState() => _LoanScreenState();
// }
//
// class _LoanScreenState extends State<LoanScreen> {
//   LoanService loanService = LoanService();
//   DateTime? searchStart;
//   DateTime? searchEnd;
//
//   @override
//   Widget build(BuildContext context) {
//     String searchText = '指定なし';
//     if (searchStart != null && searchEnd != null) {
//       searchText =
//           '${dateText('yyyy/MM/dd', searchStart)}～${dateText('yyyy/MM/dd', searchEnd)}';
//     }
//     return Stack(
//       children: [
//         const AnimationBackground(),
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   InfoLabel(
//                     label: '期間検索',
//                     child: Button(
//                       child: Text(searchText),
//                       onPressed: () async {
//                         var selected = await showDataRangePickerDialog(
//                           context: context,
//                           startValue: searchStart,
//                           endValue: searchEnd,
//                         );
//                         if (selected != null &&
//                             selected.first != null &&
//                             selected.last != null) {
//                           var diff = selected.last!.difference(selected.first!);
//                           int diffDays = diff.inDays;
//                           if (diffDays > 31) {
//                             if (!mounted) return;
//                             showMessage(context, '1ヵ月以上の範囲が選択されています', false);
//                             return;
//                           }
//                           searchStart = selected.first;
//                           searchEnd = selected.last;
//                           setState(() {});
//                         }
//                       },
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       CustomButtonSm(
//                         icon: FluentIcons.list,
//                         labelText: '返却済一覧',
//                         labelColor: kWhiteColor,
//                         backgroundColor: kGreyColor,
//                         onPressed: () => Navigator.push(
//                           context,
//                           FluentPageRoute(
//                             builder: (context) => LoanHistoryScreen(
//                               loginProvider: widget.loginProvider,
//                               homeProvider: widget.homeProvider,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       CustomButtonSm(
//                         icon: FluentIcons.add,
//                         labelText: '貸出追加',
//                         labelColor: kWhiteColor,
//                         backgroundColor: kBlueColor,
//                         onPressed: () => Navigator.push(
//                           context,
//                           FluentPageRoute(
//                             builder: (context) => LoanAddScreen(
//                               loginProvider: widget.loginProvider,
//                               homeProvider: widget.homeProvider,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Expanded(
//                 child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                   stream: loanService.streamList(
//                     organizationId: widget.loginProvider.organization?.id,
//                     searchStart: searchStart,
//                     searchEnd: searchEnd,
//                     searchStatus: 0,
//                   ),
//                   builder: (context, snapshot) {
//                     List<LoanModel> loans = [];
//                     if (snapshot.hasData) {
//                       loans = loanService.generateList(data: snapshot.data);
//                     }
//                     if (loans.isEmpty) {
//                       return const Center(child: Text('貸出データがありません'));
//                     }
//                     return GridView.builder(
//                       gridDelegate: kDefaultGridDelegate,
//                       shrinkWrap: true,
//                       itemCount: loans.length,
//                       itemBuilder: (context, index) {
//                         LoanModel loan = loans[index];
//                         return LoanCard(
//                           loan: loan,
//                           onTap: () => Navigator.push(
//                             context,
//                             FluentPageRoute(
//                               builder: (context) => LoanModScreen(
//                                 loginProvider: widget.loginProvider,
//                                 homeProvider: widget.homeProvider,
//                                 loan: loan,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
