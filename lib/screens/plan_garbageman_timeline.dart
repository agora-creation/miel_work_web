import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/custom_date_time_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/plan_garbageman.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/plan_garbageman.dart';
import 'package:miel_work_web/screens/plan_garbageman.dart';
import 'package:miel_work_web/services/plan_garbageman.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/form_label.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:miel_work_web/widgets/plan_garbageman_list.dart';
import 'package:provider/provider.dart';

class PlanGarbagemanTimelineScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final DateTime day;

  const PlanGarbagemanTimelineScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.day,
    super.key,
  });

  @override
  State<PlanGarbagemanTimelineScreen> createState() =>
      _PlanGarbagemanTimelineScreenState();
}

class _PlanGarbagemanTimelineScreenState
    extends State<PlanGarbagemanTimelineScreen> {
  PlanGarbagemanService garbagemanService = PlanGarbagemanService();

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
          '${dateText('yyyy/MM/dd', widget.day)}：清掃員予定表',
          style: const TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: '清掃員予定を追加',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AddGarbagemanDialog(
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
            stream: garbagemanService.streamList(
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
              List<PlanGarbagemanModel> garbageMans = [];
              if (snapshot.hasData) {
                garbageMans = garbagemanService.generateList(
                  data: snapshot.data,
                );
              }
              if (garbageMans.isEmpty) {
                return const Center(child: Text('この日の予定はありません'));
              }
              return Column(
                children: garbageMans.map((garbageman) {
                  return PlanGarbagemanList(
                    garbageman: garbageman,
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => ModGarbagemanDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                        garbageman: garbageman,
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

class ModGarbagemanDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final PlanGarbagemanModel garbageman;

  const ModGarbagemanDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.garbageman,
    super.key,
  });

  @override
  State<ModGarbagemanDialog> createState() => _ModGarbagemanDialogState();
}

class _ModGarbagemanDialogState extends State<ModGarbagemanDialog> {
  TextEditingController contentController = TextEditingController();
  DateTime eventAt = DateTime.now();

  @override
  void initState() {
    contentController.text = widget.garbageman.content;
    eventAt = widget.garbageman.eventAt;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final garbagemanProvider = Provider.of<PlanGarbagemanProvider>(context);
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
            String? error = await garbagemanProvider.delete(
              garbageman: widget.garbageman,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '清掃員予定が削除されました', true);
            Navigator.pop(context);
          },
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '保存する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await garbagemanProvider.update(
              garbageman: widget.garbageman,
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
            showMessage(context, '清掃員予定が変更されました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
