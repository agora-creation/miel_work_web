import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const kBackgroundColor = Color(0xFFFFD54F);
const kWhiteColor = Color(0xFFFFFFFF);
const kBlackColor = Color(0xFF333333);
const kGreyColor = Color(0xFF9E9E9E);
const kRedColor = Color(0xFFF44336);
const kBlueColor = Color(0xFF2196F3);
const kLightBlueColor = Color(0xFF03A9F4);
const kCyanColor = Color(0xFF00BCD4);
const kOrangeColor = Color(0xFFFF9800);
const kDeepOrangeColor = Color(0xFFFF5722);
const kYellowColor = Color(0xFFFFEB3B);
const kGreenColor = Color(0xFF4CAF50);
const kLightGreenColor = Color(0xFF8BC34A);
const kAmberColor = Color(0xFFFFC107);

const kSearchColor = Color(0xFF4FC3F7);
const kSaturdayColor = Color(0xFF03A9F4);
const kSundayColor = Color(0xFFFF5722);
const kDisabledColor = Color(0xFF757575);
const kCheckColor = Color(0xFF8BC34A);
const kApprovalColor = Color(0xFF009688);
const kRejectColor = Color(0xFFFF5722);
const kReturnColor = Color(0xFF00ACC1);
const kPdfColor = Color(0xFFFF5252);
Color kBorderColor = const Color(0xFF9E9E9E).withOpacity(0.5);

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
      unselectedItemColor: kDisabledColor,
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

BoxDecoration kHeaderDecoration = BoxDecoration(
  color: kWhiteColor,
  border: Border(bottom: BorderSide(color: kBorderColor)),
);

List<String> kWeeks = ['月', '火', '水', '木', '金', '土', '日'];
List<String> kRepeatIntervals = ['毎日', '毎週', '毎月', '毎年'];
List<int> kAlertMinutes = [0, 10, 30, 60];

DateTime kFirstDate = DateTime.now().subtract(const Duration(days: 1095));
DateTime kLastDate = DateTime.now().add(const Duration(days: 1095));

const kHomeGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 5,
  childAspectRatio: 1,
  crossAxisSpacing: 8,
  mainAxisSpacing: 8,
);

const kLostGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 4,
  childAspectRatio: 1,
  crossAxisSpacing: 8,
  mainAxisSpacing: 8,
);

const kLoanGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 4,
  childAspectRatio: 1,
  crossAxisSpacing: 8,
  mainAxisSpacing: 8,
);

const kReportHeaderStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  fontFamily: 'SourceHanSansJP-Bold',
);

const List<String> imageExtensions = [
  '.HEIC',
  '.heic',
  '.JPEG',
  '.jpeg',
  '.JPG',
  '.jpg',
  '.GIF',
  '.gif',
  '.PNG',
  '.png',
];

const List<String> pdfExtensions = [
  '.pdf',
];
