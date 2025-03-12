import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/request_const.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/request_const_history_source.dart';
import 'package:miel_work_web/services/request_const.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_data_grid.dart';
import 'package:miel_work_web/widgets/custom_icon_text_button.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RequestConstHistoryScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const RequestConstHistoryScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<RequestConstHistoryScreen> createState() =>
      _RequestConstHistoryScreenState();
}

class _RequestConstHistoryScreenState extends State<RequestConstHistoryScreen> {
  RequestConstService constService = RequestConstService();
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
          '社外申請申請：店舗工事作業申請：承認済一覧',
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      label: '件名検索: ',
                      labelColor: kWhiteColor,
                      backgroundColor: kSearchColor,
                      leftIcon: FontAwesomeIcons.magnifyingGlass,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: constService.streamList(
                  searchStart: searchStart,
                  searchEnd: searchEnd,
                  approval: [1, 9],
                ),
                builder: (context, snapshot) {
                  List<RequestConstModel> requestConsts = [];
                  if (snapshot.hasData) {
                    requestConsts = constService.generateList(snapshot.data);
                  }
                  return CustomDataGrid(
                    source: RequestConstHistorySource(
                      context: context,
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      requestConsts: requestConsts,
                    ),
                    columns: [
                      GridColumn(
                        columnName: 'approvedAt',
                        label: const CustomColumnLabel('承認日時'),
                      ),
                      GridColumn(
                        columnName: 'createdAt',
                        label: const CustomColumnLabel('申請日時'),
                      ),
                      GridColumn(
                        columnName: 'shopName',
                        label: const CustomColumnLabel('店舗名'),
                      ),
                      GridColumn(
                        columnName: 'shopUserName',
                        label: const CustomColumnLabel('店舗責任者名'),
                      ),
                      GridColumn(
                        columnName: 'shopUserEmail',
                        label: const CustomColumnLabel('店舗責任者メールアドレス'),
                      ),
                      GridColumn(
                        columnName: 'shopUserTel',
                        label: const CustomColumnLabel('店舗責任者電話番号'),
                      ),
                      GridColumn(
                        columnName: 'approval',
                        label: const CustomColumnLabel('ステータス'),
                      ),
                      GridColumn(
                        columnName: 'edit',
                        label: const CustomColumnLabel('操作'),
                        width: 200,
                      ),
                    ],
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
