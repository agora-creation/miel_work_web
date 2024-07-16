import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/widgets/animation_background.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          AnimationBackground(),
          Center(
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'ひろめWORK',
                        style: TextStyle(
                          color: kBlackColor,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SourceHanSansJP-Bold',
                          letterSpacing: 4,
                        ),
                      ),
                      Text(
                        'WEBアプリ',
                        style: TextStyle(
                          color: kBlackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SourceHanSansJP-Bold',
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  SpinKitFadingCircle(color: kBlackColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
