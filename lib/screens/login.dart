import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/home.dart';
import 'package:miel_work_web/widgets/animation_background.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_form_field.dart';
import 'package:miel_work_web/widgets/link_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          const AnimationBackground(),
          Center(
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Column(
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
                  const SizedBox(height: 40),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          CustomTextFormField(
                            controller: emailController,
                            textInputType: TextInputType.emailAddress,
                            maxLines: 1,
                            label: 'メールアドレス',
                            color: kBlackColor,
                            prefix: Icons.email,
                          ),
                          const SizedBox(height: 8),
                          CustomTextFormField(
                            controller: passwordController,
                            textInputType: TextInputType.visiblePassword,
                            maxLines: 1,
                            label: 'パスワード',
                            color: kBlackColor,
                            prefix: Icons.password,
                            obscureText: true,
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            type: ButtonSizeType.lg,
                            label: 'ログイン',
                            labelColor: kWhiteColor,
                            backgroundColor: kBlueColor,
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              String? error = await loginProvider.login(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              if (error != null) {
                                if (!mounted) return;
                                showMessage(context, error, false);
                                setState(() {
                                  isLoading = false;
                                });
                                return;
                              }
                              if (!mounted) return;
                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: const HomeScreen(),
                                ),
                              );
                            },
                            disabled: isLoading,
                          ),
                          const SizedBox(height: 16),
                          LinkText(
                            label: '操作マニュアル',
                            color: kBlueColor,
                            onTap: () async {
                              Uri url = Uri.parse(
                                'https://agora-c.com/miel-work/manual_web.pdf',
                              );
                              if (!await launchUrl(url)) {
                                throw Exception('Could not launch $url');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
