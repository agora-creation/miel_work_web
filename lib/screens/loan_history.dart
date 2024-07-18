import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/loan.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/loan_history_source.dart';
import 'package:miel_work_web/services/loan.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_data_grid.dart';
import 'package:miel_work_web/widgets/custom_icon_text_button.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LoanHistoryScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const LoanHistoryScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<LoanHistoryScreen> createState() => _LoanHistoryScreenState();
}

class _LoanHistoryScreenState extends State<LoanHistoryScreen> {
  LoanService loanService = LoanService();
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
          '過去の貸出／返却履歴',
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
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIconTextButton(
                  label: '期間検索: $searchText',
                  labelColor: kWhiteColor,
                  backgroundColor: kLightBlueColor,
                  leftIcon: FontAwesomeIcons.searchengin,
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
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: loanService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  searchStart: searchStart,
                  searchEnd: searchEnd,
                  searchStatus: [1, 9],
                ),
                builder: (context, snapshot) {
                  List<LoanModel> loans = [];
                  if (snapshot.hasData) {
                    loans = loanService.generateList(data: snapshot.data);
                  }
                  return CustomDataGrid(
                    source: LoanHistorySource(
                      context: context,
                      loans: loans,
                    ),
                    columns: [
                      GridColumn(
                        columnName: 'returnAt',
                        label: const CustomColumnLabel('返却日'),
                      ),
                      GridColumn(
                        columnName: 'returnUser',
                        label: const CustomColumnLabel('返却スタッフ'),
                      ),
                      GridColumn(
                        columnName: 'signImage',
                        label: const CustomColumnLabel('署名'),
                      ),
                      GridColumn(
                        columnName: 'itemName',
                        label: const CustomColumnLabel('品名'),
                      ),
                      GridColumn(
                        columnName: 'loanAt',
                        label: const CustomColumnLabel('貸出日'),
                      ),
                      GridColumn(
                        columnName: 'loanUser',
                        label: const CustomColumnLabel('貸出先'),
                      ),
                      GridColumn(
                        columnName: 'loanCompany',
                        label: const CustomColumnLabel('貸出先(会社)'),
                      ),
                      GridColumn(
                        columnName: 'loanStaff',
                        label: const CustomColumnLabel('対応スタッフ'),
                      ),
                      GridColumn(
                        columnName: 'returnPlanAt',
                        label: const CustomColumnLabel('返却予定日'),
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
