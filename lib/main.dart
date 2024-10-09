import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/providers/apply.dart';
import 'package:miel_work_web/providers/category.dart';
import 'package:miel_work_web/providers/chat_message.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/loan.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/lost.dart';
import 'package:miel_work_web/providers/notice.dart';
import 'package:miel_work_web/providers/plan.dart';
import 'package:miel_work_web/providers/problem.dart';
import 'package:miel_work_web/providers/report.dart';
import 'package:miel_work_web/providers/request_interview.dart';
import 'package:miel_work_web/providers/request_square.dart';
import 'package:miel_work_web/providers/user.dart';
import 'package:miel_work_web/screens/home.dart';
import 'package:miel_work_web/screens/login.dart';
import 'package:miel_work_web/screens/splash.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCGD81RyrbghjAaMIyfbUP7IF1i305jDYI",
      authDomain: "miel-work-project.firebaseapp.com",
      projectId: "miel-work-project",
      storageBucket: "miel-work-project.appspot.com",
      messagingSenderId: "66212259980",
      appId: "1:66212259980:web:0f8cc5c0b2aa70f13933a9",
      measurementId: "G-K4F35RVP9R",
    ),
  );
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  if (FirebaseAuth.instance.currentUser == null) {
    await Future.any([
      FirebaseAuth.instance.userChanges().firstWhere((e) => e != null),
      Future.delayed(const Duration(milliseconds: 3000)),
    ]);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: LoginProvider.initialize()),
        ChangeNotifierProvider.value(value: HomeProvider()),
        ChangeNotifierProvider.value(value: UserProvider()),
        ChangeNotifierProvider.value(value: NoticeProvider()),
        ChangeNotifierProvider.value(value: ChatMessageProvider()),
        ChangeNotifierProvider.value(value: CategoryProvider()),
        ChangeNotifierProvider.value(value: PlanProvider()),
        ChangeNotifierProvider.value(value: ApplyProvider()),
        ChangeNotifierProvider.value(value: ProblemProvider()),
        ChangeNotifierProvider.value(value: ReportProvider()),
        ChangeNotifierProvider.value(value: LostProvider()),
        ChangeNotifierProvider.value(value: LoanProvider()),
        ChangeNotifierProvider.value(value: RequestInterviewProvider()),
        ChangeNotifierProvider.value(value: RequestSquareProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          SfGlobalLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ja')],
        locale: const Locale('ja'),
        title: 'ひろめWORK - WEBアプリ',
        theme: customTheme(),
        home: const SplashController(),
      ),
    );
  }
}

class SplashController extends StatelessWidget {
  const SplashController({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    switch (loginProvider.status) {
      case AuthStatus.uninitialized:
        return const SplashScreen();
      case AuthStatus.unauthenticated:
      case AuthStatus.authenticating:
        return const LoginScreen();
      case AuthStatus.authenticated:
        return const HomeScreen();
      default:
        return const LoginScreen();
    }
  }
}
