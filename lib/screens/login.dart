import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/home.dart';
import 'package:miel_work_web/widgets/animation_background.dart';
import 'package:miel_work_web/widgets/custom_button_lg.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:miel_work_web/widgets/link_text.dart';
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

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    return ScaffoldPage(
      content: Stack(
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
                          letterSpacing: 4,
                        ),
                      ),
                      Text(
                        '管理画面',
                        style: TextStyle(
                          color: kBlackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          InfoLabel(
                            label: 'メールアドレス',
                            child: CustomTextBox(
                              controller: emailController,
                              placeholder: '',
                              keyboardType: TextInputType.emailAddress,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InfoLabel(
                            label: 'パスワード',
                            child: CustomTextBox(
                              controller: passwordController,
                              placeholder: '',
                              keyboardType: TextInputType.visiblePassword,
                              maxLines: 1,
                              obscureText: true,
                            ),
                          ),
                          const SizedBox(height: 24),
                          CustomButtonLg(
                            labelText: 'ログイン',
                            labelColor: kWhiteColor,
                            backgroundColor: kBlueColor,
                            onPressed: () async {
                              String? error = await loginProvider.login(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              if (error != null) {
                                if (!mounted) return;
                                showMessage(context, error, false);
                                return;
                              }
                              if (!mounted) return;
                              showMessage(context, 'ログインに成功しました', true);
                              Navigator.pushReplacement(
                                context,
                                FluentPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          LinkText(
                            label: '操作マニュアル',
                            color: kBlueColor,
                            onTap: () async {
                              Uri url = Uri.parse(
                                  'https://agora-c.com/miel-work/manual_web.pdf');
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
