import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/screens/home.dart';
import 'package:miel_work_web/widgets/custom_button_lg.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController loginIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);

    return ScaffoldPage(
      content: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Column(
                children: [
                  Text(
                    'みえるWORK',
                    style: TextStyle(
                      color: kWhiteColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  Text(
                    '団体管理者用',
                    style: TextStyle(
                      color: kWhiteColor,
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
                        label: 'ログインID',
                        child: CustomTextBox(
                          controller: loginIdController,
                          placeholder: '',
                          keyboardType: TextInputType.text,
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
                            loginId: loginIdController.text,
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
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
