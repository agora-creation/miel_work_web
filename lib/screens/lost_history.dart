import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/lost.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/lost_history_source.dart';
import 'package:miel_work_web/services/lost.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_column_label.dart';
import 'package:miel_work_web/widgets/custom_data_grid.dart';
import 'package:miel_work_web/widgets/custom_icon_text_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/form_label.dart';
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
  String? searchItemName;

  void _getItemName() async {
    searchItemName = await getPrefsString('itemName');
    setState(() {});
  }

  @override
  void initState() {
    _getItemName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String searchText = '指定なし';
    if (searchStart != null && searchEnd != null) {
      searchText =
          '${dateText('yyyy/MM/dd', searchStart)}～${dateText('yyyy/MM/dd', searchEnd)}';
    }
    String searchItemNameText = '指定なし';
    if (searchItemName != null) {
      searchItemNameText = '$searchItemName';
    }
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        title: const Text(
          '落とし物：返却済一覧',
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
                      label: '品名検索: $searchItemNameText',
                      labelColor: kWhiteColor,
                      backgroundColor: kSearchColor,
                      leftIcon: FontAwesomeIcons.magnifyingGlass,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => SearchItemNameDialog(
                          getItemName: _getItemName,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: lostService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  searchStart: searchStart,
                  searchEnd: searchEnd,
                  searchStatus: [1, 9],
                ),
                builder: (context, snapshot) {
                  List<LostModel> losts = [];
                  if (snapshot.hasData) {
                    losts = lostService.generateList(
                      data: snapshot.data,
                      itemName: searchItemName,
                    );
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
                        columnName: 'itemNumber',
                        label: const CustomColumnLabel('落とし物No'),
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

class SearchItemNameDialog extends StatefulWidget {
  final Function() getItemName;

  const SearchItemNameDialog({
    required this.getItemName,
    super.key,
  });

  @override
  State<SearchItemNameDialog> createState() => _SearchItemNameDialogState();
}

class _SearchItemNameDialogState extends State<SearchItemNameDialog> {
  TextEditingController itemNameController = TextEditingController();

  void _getItemName() async {
    itemNameController = TextEditingController(
      text: await getPrefsString('itemName') ?? '',
    );
    setState(() {});
  }

  @override
  void initState() {
    _getItemName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            FormLabel(
              '品名',
              child: CustomTextField(
                controller: itemNameController,
                textInputType: TextInputType.text,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '検索する',
          labelColor: kWhiteColor,
          backgroundColor: kSearchColor,
          onPressed: () async {
            await setPrefsString('itemName', itemNameController.text);
            widget.getItemName();
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
