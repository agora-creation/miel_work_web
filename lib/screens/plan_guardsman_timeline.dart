import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/plan_guardsman.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/plan_guardsman.dart';
import 'package:miel_work_web/screens/plan_guardsman.dart';
import 'package:miel_work_web/services/plan_guardsman.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:miel_work_web/widgets/plan_guardsman_list.dart';
import 'package:provider/provider.dart';

class PlanGuardsmanTimelineScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final DateTime day;

  const PlanGuardsmanTimelineScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.day,
    super.key,
  });

  @override
  State<PlanGuardsmanTimelineScreen> createState() =>
      _PlanGuardsmanTimelineScreenState();
}

class _PlanGuardsmanTimelineScreenState
    extends State<PlanGuardsmanTimelineScreen> {
  PlanGuardsmanService guardsmanService = PlanGuardsmanService();

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          '${dateText('yyyy/MM/dd', widget.day)}：警備員予定表',
          style: const TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: '警備員予定を追加',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AddGuardsmanDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                day: widget.day,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 200,
        ),
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: guardsmanService.streamList(
              organizationId: widget.loginProvider.organization?.id,
              searchStart: widget.day,
              searchEnd: DateTime(
                widget.day.year,
                widget.day.month,
                widget.day.day,
                23,
                59,
                59,
              ),
            ),
            builder: (context, snapshot) {
              List<PlanGuardsmanModel> guardsMans = [];
              if (snapshot.hasData) {
                guardsMans = guardsmanService.generateList(
                  data: snapshot.data,
                );
              }
              if (guardsMans.isEmpty) {
                return const Center(child: Text('この日の予定はありません'));
              }
              return Column(
                children: guardsMans.map((guardsman) {
                  return PlanGuardsmanList(
                    guardsman: guardsman,
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => ModGuardsmanDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                        guardsman: guardsman,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ModGuardsmanDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final PlanGuardsmanModel guardsman;

  const ModGuardsmanDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.guardsman,
    super.key,
  });

  @override
  State<ModGuardsmanDialog> createState() => _ModGuardsmanDialogState();
}

class _ModGuardsmanDialogState extends State<ModGuardsmanDialog> {
  TextEditingController contentController = TextEditingController();
  DateTime eventAt = DateTime.now();

  @override
  void initState() {
    contentController.text = widget.guardsman.content;
    eventAt = widget.guardsman.eventAt;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final guardsmanProvider = Provider.of<PlanGuardsmanProvider>(context);
    return CustomAlertDialog(
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FormLabel(
              '内容',
              child: CustomTextField(
                controller: contentController,
                textInputType: TextInputType.text,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
            FormLabel(
              '予定日',
              child: FormValue(
                dateText('yyyy/MM/dd', eventAt),
                onTap: () async => await CustomDateTimePicker().picker(
                  context: context,
                  init: eventAt,
                  title: '予定日を選択',
                  onChanged: (value) {
                    setState(() {
                      eventAt = value;
                    });
                  },
                  datetime: false,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '削除する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await guardsmanProvider.delete(
              guardsman: widget.guardsman,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '警備員予定が削除されました', true);
            Navigator.pop(context);
          },
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '保存する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await guardsmanProvider.update(
              guardsman: widget.guardsman,
              organization: widget.loginProvider.organization,
              content: contentController.text,
              eventAt: eventAt,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '警備員予定が変更されました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
