import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/widgets/custom_icon_text_button.dart';
import 'package:miel_work_web/widgets/day_list.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class WorkScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const WorkScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  DateTime searchMonth = DateTime.now();
  List<DateTime> days = [];

  void _changeMonth(DateTime value) {
    searchMonth = value;
    days = generateDays(value);
    setState(() {});
  }

  void _init() {
    days = generateDays(searchMonth);
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        title: const Text(
          '勤怠打刻',
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
                      label: '年月検索: ${dateText('yyyy年MM月', searchMonth)}',
                      labelColor: kWhiteColor,
                      backgroundColor: kSearchColor,
                      leftIcon: FontAwesomeIcons.magnifyingGlass,
                      onPressed: () async {
                        DateTime? selected = await showMonthPicker(
                          context: context,
                          initialDate: searchMonth,
                          monthPickerDialogSettings:
                              const MonthPickerDialogSettings(
                            dialogSettings: PickerDialogSettings(
                              locale: Locale('ja'),
                            ),
                          ),
                        );
                        if (selected == null) return;
                        _changeMonth(selected);
                      },
                    ),
                    const SizedBox(width: 4),
                    CustomIconTextButton(
                      label: 'スタッフ検索: 指定なし',
                      labelColor: kWhiteColor,
                      backgroundColor: kSearchColor,
                      leftIcon: FontAwesomeIcons.magnifyingGlass,
                      onPressed: () async {},
                    ),
                  ],
                ),
                CustomIconTextButton(
                  label: '打刻情報を追加',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  leftIcon: FontAwesomeIcons.plus,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: kBorderColor),
                ),
                child: ListView.builder(
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    DateTime day = days[index];
                    return DayList(
                      day,
                      child: Container(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
