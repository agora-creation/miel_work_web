import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/problem.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/problem.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
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
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: kBlackColor,
            size: 16,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'クレーム／要望を削除',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: '削除する',
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
          const SizedBox(width: 8),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey300Color)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 200,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FormLabel(
                      '報告日時',
                      child: FormValue(
                        dateText('yyyy/MM/dd HH:mm', widget.problem.createdAt),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FormLabel(
                      '対応項目',
                      child: FormValue(widget.problem.type),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FormLabel(
                      '対応者',
                      child: FormValue(widget.problem.picName),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        FormLabel(
                          '相手の名前',
                          child: FormValue(widget.problem.targetName),
                        ),
                        const SizedBox(height: 4),
                        FormLabel(
                          '相手の年齢',
                          child: FormValue(widget.problem.targetAge),
                        ),
                        const SizedBox(height: 4),
                        FormLabel(
                          '相手の連絡先',
                          child: FormValue(widget.problem.targetTel),
                        ),
                        const SizedBox(height: 4),
                        FormLabel(
                          '相手の住所',
                          child: FormValue(widget.problem.targetAddress),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              FormLabel(
                '詳細',
                child: FormValue(widget.problem.details),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付写真',
                child: widget.problem.image != ''
                    ? Image.network(
                        widget.problem.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : Container(
                        color: kGrey300Color,
                        width: double.infinity,
                        height: 150,
                        child: const Center(
                          child: Text('写真が選択されていません'),
                        ),
                      ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '対応状態',
                child: FormValue(widget.problem.stateText()),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '同じような注意(対応)をした回数',
                child: FormValue(widget.problem.count.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
