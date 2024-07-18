import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/services/lost.dart';

class LostScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const LostScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<LostScreen> createState() => _LostScreenState();
}

class _LostScreenState extends State<LostScreen> {
  LostService lostService = LostService();
  DateTime? searchStart;
  DateTime? searchEnd;

  @override
  Widget build(BuildContext context) {
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
          '落とし物',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: kBlackColor),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
    );

    // return Stack(
    //   children: [
    //     const AnimationBackground(),
    //     Padding(
    //       padding: const EdgeInsets.all(16),
    //       child: Column(
    //         children: [
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             crossAxisAlignment: CrossAxisAlignment.end,
    //             children: [
    //               InfoLabel(
    //                 label: '期間検索',
    //                 child: Button(
    //                   child: Text(searchText),
    //                   onPressed: () async {
    //                     var selected = await showDataRangePickerDialog(
    //                       context: context,
    //                       startValue: searchStart,
    //                       endValue: searchEnd,
    //                     );
    //                     if (selected != null &&
    //                         selected.first != null &&
    //                         selected.last != null) {
    //                       var diff = selected.last!.difference(selected.first!);
    //                       int diffDays = diff.inDays;
    //                       if (diffDays > 31) {
    //                         if (!mounted) return;
    //                         showMessage(context, '1ヵ月以上の範囲が選択されています', false);
    //                         return;
    //                       }
    //                       searchStart = selected.first;
    //                       searchEnd = selected.last;
    //                       setState(() {});
    //                     }
    //                   },
    //                 ),
    //               ),
    //               Row(
    //                 children: [
    //                   CustomButtonSm(
    //                     icon: FluentIcons.list,
    //                     labelText: '返却済一覧',
    //                     labelColor: kWhiteColor,
    //                     backgroundColor: kGreyColor,
    //                     onPressed: () => Navigator.push(
    //                       context,
    //                       FluentPageRoute(
    //                         builder: (context) => LostHistoryScreen(
    //                           loginProvider: widget.loginProvider,
    //                           homeProvider: widget.homeProvider,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                   const SizedBox(width: 4),
    //                   CustomButtonSm(
    //                     icon: FluentIcons.add,
    //                     labelText: '落とし物追加',
    //                     labelColor: kWhiteColor,
    //                     backgroundColor: kBlueColor,
    //                     onPressed: () => Navigator.push(
    //                       context,
    //                       FluentPageRoute(
    //                         builder: (context) => LostAddScreen(
    //                           loginProvider: widget.loginProvider,
    //                           homeProvider: widget.homeProvider,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //           const SizedBox(height: 8),
    //           Expanded(
    //             child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    //               stream: lostService.streamList(
    //                 organizationId: widget.loginProvider.organization?.id,
    //                 searchStart: searchStart,
    //                 searchEnd: searchEnd,
    //                 searchStatus: 0,
    //               ),
    //               builder: (context, snapshot) {
    //                 List<LostModel> losts = [];
    //                 if (snapshot.hasData) {
    //                   losts = lostService.generateList(data: snapshot.data);
    //                 }
    //                 if (losts.isEmpty) {
    //                   return const Center(child: Text('落とし物データがありません'));
    //                 }
    //                 return GridView.builder(
    //                   gridDelegate: kDefaultGridDelegate,
    //                   shrinkWrap: true,
    //                   itemCount: losts.length,
    //                   itemBuilder: (context, index) {
    //                     LostModel lost = losts[index];
    //                     return LostCard(
    //                       lost: lost,
    //                       onTap: () => Navigator.push(
    //                         context,
    //                         FluentPageRoute(
    //                           builder: (context) => LostModScreen(
    //                             loginProvider: widget.loginProvider,
    //                             homeProvider: widget.homeProvider,
    //                             lost: lost,
    //                           ),
    //                         ),
    //                       ),
    //                     );
    //                   },
    //                 );
    //               },
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}
