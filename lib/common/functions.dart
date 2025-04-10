import 'package:alert_banner/exports.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miel_work_web/common/date_machine_util.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/widgets/custom_alert_banner.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as uhtml;
import 'package:url_launcher/url_launcher.dart';

void showMessage(BuildContext context, String msg, bool success) {
  showAlertBanner(
    context,
    () {},
    CustomAlertBanner(msg: msg, success: success),
    alertBannerLocation: AlertBannerLocation.top,
  );
}

void showBottomUpScreen(BuildContext context, Widget widget) {
  showMaterialModalBottomSheet(
    expand: true,
    context: context,
    builder: (context) => widget,
  );
}

Future<int?> getPrefsInt(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(key);
}

Future setPrefsInt(String key, int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(key, value);
}

Future<String?> getPrefsString(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future setPrefsString(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

Future<bool?> getPrefsBool(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key);
}

Future setPrefsBool(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
}

Future<List<String>?> getPrefsList(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(key);
}

Future setPrefsList(String key, List<String> value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList(key, value);
}

Future removePrefs(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}

Future allRemovePrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

String dateText(String format, DateTime? date) {
  String ret = '';
  if (date != null) {
    ret = DateFormat(format, 'ja').format(date);
  }
  return ret;
}

Future<List<DateTime?>?> showDataRangePickerDialog({
  required BuildContext context,
  DateTime? startValue,
  DateTime? endValue,
}) async {
  List<DateTime?>? results = await showCalendarDatePicker2Dialog(
    context: context,
    config: CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
      firstDate: kFirstDate,
      lastDate: kLastDate,
    ),
    dialogSize: const Size(325, 400),
    value: [startValue, endValue],
    borderRadius: BorderRadius.circular(8),
    dialogBackgroundColor: kWhiteColor,
  );
  return results;
}

Timestamp convertTimestamp(DateTime date, bool end) {
  String dateTime = '${dateText('yyyy-MM-dd', date)} 00:00:00.000';
  if (end == true) {
    dateTime = '${dateText('yyyy-MM-dd', date)} 23:59:59.999';
  }
  return Timestamp.fromMillisecondsSinceEpoch(
    DateTime.parse(dateTime).millisecondsSinceEpoch,
  );
}

String twoDigits(int n) => n.toString().padLeft(2, '0');

String addTime(String left, String right) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  List<String> lefts = left.split(':');
  List<String> rights = right.split(':');
  double hm = (int.parse(lefts.last) + int.parse(rights.last)) / 60;
  int m = (int.parse(lefts.last) + int.parse(rights.last)) % 60;
  int h = (int.parse(lefts.first) + int.parse(rights.first)) + hm.toInt();
  if (h.toString().length == 1) {
    return '${twoDigits(h)}:${twoDigits(m)}';
  } else {
    return '$h:${twoDigits(m)}';
  }
}

String subTime(String left, String right) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  List<String> lefts = left.split(':');
  List<String> rights = right.split(':');
  // 時 → 分
  int leftM = (int.parse(lefts.first) * 60) + int.parse(lefts.last);
  int rightM = (int.parse(rights.first) * 60) + int.parse(rights.last);
  // 分で引き算
  int diffM = leftM - rightM;
  // 分 → 時
  double h = diffM / 60;
  int m = diffM % 60;
  return '${twoDigits(h.toInt())}:${twoDigits(m)}';
}

List<DateTime> generateDays(DateTime month) {
  List<DateTime> ret = [];
  var dateMap = DateMachineUtil.getMonthDate(month, 0);
  DateTime startTime = DateTime.parse('${dateMap['start']}');
  DateTime endTime = DateTime.parse('${dateMap['end']}');
  for (int i = 0; i <= endTime.difference(startTime).inDays; i++) {
    ret.add(startTime.add(Duration(days: i)));
  }
  return ret;
}

DateTime rebuildDate(DateTime? date, DateTime? time) {
  DateTime ret = DateTime.now();
  if (date != null && time != null) {
    String tmpDate = dateText('yyyy-MM-dd', date);
    String tmpTime = '${dateText('HH:mm', time)}:00.000';
    ret = DateTime.parse('$tmpDate $tmpTime');
  }
  return ret;
}

DateTime rebuildTime(BuildContext context, DateTime? date, String? time) {
  DateTime ret = DateTime.now();
  if (date != null && time != null) {
    String tmpDate = dateText('yyyy-MM-dd', date);
    String tmpTime = '${time.padLeft(5, '0')}:00.000';
    ret = DateTime.parse('$tmpDate $tmpTime');
  }
  return ret;
}

String ruleConvertWeek(String week) {
  switch (week) {
    case '月':
      return 'MO';
    case '火':
      return 'TU';
    case '水':
      return 'WE';
    case '木':
      return 'TH';
    case '金':
      return 'FR';
    case '土':
      return 'SA';
    case '日':
      return 'SU';
    default:
      return '';
  }
}

RegExp _urlReg = RegExp(
  r'https?://([\w-]+\.)+[\w-]+(/[\w-./?%&=#]*)?',
);

extension TextEx on Text {
  RichText urlToLink(BuildContext context) {
    final textSpans = <InlineSpan>[];
    data!.splitMapJoin(
      _urlReg,
      onMatch: (Match match) {
        final tmpMatch = match[0] ?? '';
        textSpans.add(
          TextSpan(
            text: tmpMatch,
            style: const TextStyle(
              color: kBlueColor,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async => await launchUrl(
                    Uri.parse(tmpMatch),
                  ),
          ),
        );
        return '';
      },
      onNonMatch: (String text) {
        textSpans.add(
          TextSpan(
            text: text,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        );
        return '';
      },
    );
    return RichText(text: TextSpan(children: textSpans));
  }
}

void downloadFile({
  required String url,
  required String name,
}) {
  var anchorElement = uhtml.AnchorElement(href: url);
  anchorElement.target = 'blank';
  anchorElement.download = name;
  anchorElement.click();
}
