import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const kBackgroundColor = Color(0xFFFFD54F);
const kWhiteColor = Color(0xFFFFFFFF);
const kBlackColor = Color(0xFF333333);
const kGreyColor = Color(0xFF9E9E9E);
const kGrey600Color = Color(0xFF757575);
const kGrey300Color = Color(0xFFE0E0E0);
const kGrey200Color = Color(0xFFEEEEEE);
const kGrey100Color = Color(0xFFF5F5F5);
const kRedColor = Color(0xFFF44336);
const kRed300Color = Color(0xFFE57373);
const kRed200Color = Color(0xFFEF9A9A);
const kRed100Color = Color(0xFFFFCDD2);
const kBlueColor = Color(0xFF2196F3);
const kBlue600Color = Color(0xFF1E88E5);
const kBlue100Color = Color(0xFFBBDEFB);
const kLightBlueColor = Color(0xFF03A9F4);
const kLightBlue800Color = Color(0xFF0277BD);
const kCyanColor = Color(0xFF00BCD4);
const kOrangeColor = Color(0xFFFF9800);
const kOrange300Color = Color(0xFFFFB74D);
const kYellowColor = Color(0xFFFFEB3B);
const kGreenColor = Color(0xFF4CAF50);
const kGreen200Color = Color(0xFFA5D6A7);
const kLightGreenColor = Color(0xFF8BC34A);

ThemeData customTheme() {
  return ThemeData(
    scaffoldBackgroundColor: kBackgroundColor,
    fontFamily: 'SourceHanSansJP-Regular',
    appBarTheme: const AppBarTheme(
      color: kBackgroundColor,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: TextStyle(
        color: kWhiteColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceHanSansJP-Bold',
      ),
      iconTheme: IconThemeData(color: kWhiteColor),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: kBlackColor),
      bodyMedium: TextStyle(color: kBlackColor),
      bodySmall: TextStyle(color: kBlackColor),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: kWhiteColor,
      elevation: 5,
      selectedItemColor: kBlueColor,
      unselectedItemColor: kGrey600Color,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kBlueColor,
      elevation: 5,
      extendedTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceHanSansJP-Bold',
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    unselectedWidgetColor: kGreyColor,
  );
}

const kHeaderDecoration = BoxDecoration(
  color: kWhiteColor,
  border: Border(bottom: BorderSide(color: kGrey300Color)),
);

List<String> kWeeks = ['月', '火', '水', '木', '金', '土', '日'];
List<String> kRepeatIntervals = ['毎日', '毎週', '毎月', '毎年'];
List<int> kAlertMinutes = [0, 10, 30, 60];

DateTime kFirstDate = DateTime.now().subtract(const Duration(days: 1095));
DateTime kLastDate = DateTime.now().add(const Duration(days: 1095));

const kDefaultImageUrl = 'assets/images/default.png';

const kHomeGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 5,
  childAspectRatio: 1,
  crossAxisSpacing: 8,
  mainAxisSpacing: 8,
);

const kDefaultGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 5,
  childAspectRatio: 1,
  crossAxisSpacing: 8,
  mainAxisSpacing: 8,
);
