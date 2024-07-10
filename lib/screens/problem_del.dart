import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/problem.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/problem.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:provider/provider.dart';

class ProblemDelScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ProblemModel problem;

  const ProblemDelScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.problem,
    super.key,
  });

  @override
  State<ProblemDelScreen> createState() => _ProblemDelScreenState();
}

class _ProblemDelScreenState extends State<ProblemDelScreen> {
  @override
  Widget build(BuildContext context) {
    final problemProvider = Provider.of<ProblemProvider>(context);
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      header: Container(
        decoration: kHeaderDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(FluentIcons.chevron_left),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                'クレーム／要望を削除',
                style: TextStyle(fontSize: 16),
              ),
              CustomButtonSm(
                labelText: '削除する',
                labelColor: kWhiteColor,
                backgroundColor: kRedColor,
                onPressed: () async {
                  String? error = await problemProvider.delete(
                    problem: widget.problem,
                  );
                  if (error != null) {
                    if (!mounted) return;
                    showMessage(context, error, false);
                    return;
                  }
                  if (!mounted) return;
                  showMessage(context, 'クレーム／要望を削除しました', true);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      content: Container(
        color: kWhiteColor,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 200,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '本当に削除しますか？',
                style: TextStyle(color: kRedColor),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InfoLabel(
                      label: '報告日時',
                      child: Container(
                        color: kGrey200Color,
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          dateText(
                              'yyyy/MM/dd HH:mm', widget.problem.createdAt),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InfoLabel(
                      label: '対応項目',
                      child: Container(
                        color: kGrey200Color,
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        child: Text(widget.problem.type),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: InfoLabel(
                      label: '対応者',
                      child: Container(
                        color: kGrey200Color,
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        child: Text(widget.problem.picName),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        InfoLabel(
                          label: '相手の名前',
                          child: Container(
                            color: kGrey200Color,
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            child: Text(widget.problem.targetName),
                          ),
                        ),
                        const SizedBox(height: 4),
                        InfoLabel(
                          label: '相手の年齢',
                          child: Container(
                            color: kGrey200Color,
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            child: Text(widget.problem.targetAge),
                          ),
                        ),
                        const SizedBox(height: 4),
                        InfoLabel(
                          label: '相手の連絡先',
                          child: Container(
                            color: kGrey200Color,
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            child: Text(widget.problem.targetTel),
                          ),
                        ),
                        const SizedBox(height: 4),
                        InfoLabel(
                          label: '相手の住所',
                          child: Container(
                            color: kGrey200Color,
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            child: Text(widget.problem.targetAddress),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: '詳細',
                child: Container(
                  color: kGrey200Color,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: Text(widget.problem.details),
                ),
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: '添付写真',
                child: Container(
                  color: kGrey200Color,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: Text(widget.problem.image),
                ),
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: '対応状態',
                child: Container(
                  color: kGrey200Color,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: Text(widget.problem.states.toString()),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
