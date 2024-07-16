import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/lost.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/lost_history_source.dart';
import 'package:miel_work_web/services/lost.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_data_grid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class LostHistoryScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const LostHistoryScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<LostHistoryScreen> createState() => _LostHistoryScreenState();
}

class _LostHistoryScreenState extends State<LostHistoryScreen> {
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
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      header: Container(
        decoration: kHeaderDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '落とし物 返却済一覧',
                style: TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: const Icon(FluentIcons.clear),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
              ),
            ],
          ),
        ),
      ),
      content: Container(
        color: kWhiteColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InfoLabel(
                  label: '期間検索',
                  child: Button(
                    child: Text(searchText),
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
                ),
                Container(),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: lostService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  searchStart: searchStart,
                  searchEnd: searchEnd,
                  searchStatus: 1,
                ),
                builder: (context, snapshot) {
                  List<LostModel> losts = [];
                  if (snapshot.hasData) {
                    losts = lostService.generateList(data: snapshot.data);
                  }
                  return CustomDataGrid(
                    source: LostHistorySource(
                      context: context,
                      losts: losts,
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
                        columnName: 'discoveryAt',
                        label: const CustomColumnLabel('発見日'),
                      ),
                      GridColumn(
                        columnName: 'discoveryPlace',
                        label: const CustomColumnLabel('発見場所'),
                      ),
                      GridColumn(
                        columnName: 'discoveryUser',
                        label: const CustomColumnLabel('発見者'),
                      ),
                      GridColumn(
                        columnName: 'remarks',
                        label: const CustomColumnLabel('備考'),
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
