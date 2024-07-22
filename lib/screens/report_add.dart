import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/providers/report.dart';
import 'package:miel_work_web/widgets/custom_alert_dialog.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:miel_work_web/widgets/form_value.dart';
import 'package:provider/provider.dart';

class ReportAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final DateTime day;

  const ReportAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.day,
    super.key,
  });

  @override
  State<ReportAddScreen> createState() => _ReportAddScreenState();
}

class _ReportAddScreenState extends State<ReportAddScreen> {
  DateTime createdAt = DateTime.now();
  String workUser1Name = '';
  String workUser1Time = '';
  String workUser2Name = '';
  String workUser2Time = '';
  String workUser3Name = '';
  String workUser3Time = '';
  String workUser4Name = '';
  String workUser4Time = '';
  String workUser5Name = '';
  String workUser5Time = '';
  String workUser6Name = '';
  String workUser6Time = '';
  String workUser7Name = '';
  String workUser7Time = '';
  String workUser8Name = '';
  String workUser8Time = '';
  String workUser9Name = '';
  String workUser9Time = '';
  String workUser10Name = '';
  String workUser10Time = '';
  String workUser11Name = '';
  String workUser11Time = '';
  String workUser12Name = '';
  String workUser12Time = '';
  String workUser13Name = '';
  String workUser13Time = '';
  String workUser14Name = '';
  String workUser14Time = '';
  String workUser15Name = '';
  String workUser15Time = '';
  String workUser16Name = '';
  String workUser16Time = '';

  @override
  void initState() {
    createdAt = widget.day;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
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
          '${dateText('MM月dd日(E)', widget.day)}の日報',
          style: const TextStyle(color: kBlackColor),
        ),
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: '保存する',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () async {
              String? error = await reportProvider.create(
                organization: widget.loginProvider.organization,
                createdAt: createdAt,
                workUser1Name: workUser1Name,
                workUser1Time: workUser1Time,
                workUser2Name: workUser2Name,
                workUser2Time: workUser2Time,
                workUser3Name: workUser3Name,
                workUser3Time: workUser3Time,
                workUser4Name: workUser4Name,
                workUser4Time: workUser4Time,
                workUser5Name: workUser5Name,
                workUser5Time: workUser5Time,
                workUser6Name: workUser6Name,
                workUser6Time: workUser6Time,
                workUser7Name: workUser7Name,
                workUser7Time: workUser7Time,
                workUser8Name: workUser8Name,
                workUser8Time: workUser8Time,
                workUser9Name: workUser9Name,
                workUser9Time: workUser9Time,
                workUser10Name: workUser10Name,
                workUser10Time: workUser10Time,
                workUser11Name: workUser11Name,
                workUser11Time: workUser11Time,
                workUser12Name: workUser12Name,
                workUser12Time: workUser12Time,
                workUser13Name: workUser13Name,
                workUser13Time: workUser13Time,
                workUser14Name: workUser14Name,
                workUser14Time: workUser14Time,
                workUser15Name: workUser15Name,
                workUser15Time: workUser15Time,
                workUser16Name: workUser16Name,
                workUser16Time: workUser16Time,
                loginUser: widget.loginProvider.user,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, '日報が保存されました', true);
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '本日の出勤者',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        const Text('インフォメーション'),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('①'),
                                ),
                                FormValue(
                                  workUser1Name,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser1Name,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser1Name = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                FormValue(
                                  workUser1Time,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser1Time,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser1Time = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('②'),
                                ),
                                FormValue(
                                  workUser2Name,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser2Name,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser2Name = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                FormValue(
                                  workUser2Time,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser2Time,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser2Time = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('③'),
                                ),
                                FormValue(
                                  workUser3Name,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser3Name,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser3Name = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                FormValue(
                                  workUser3Time,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser3Time,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser3Time = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('④'),
                                ),
                                FormValue(
                                  workUser4Name,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser4Name,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser4Name = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                FormValue(
                                  workUser4Time,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser4Time,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser4Time = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('⑤'),
                                ),
                                FormValue(
                                  workUser5Name,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser5Name,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser5Name = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                FormValue(
                                  workUser5Time,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser5Time,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser5Time = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('⑥'),
                                ),
                                FormValue(
                                  workUser6Name,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser6Name,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser6Name = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                FormValue(
                                  workUser6Time,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser6Time,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser6Time = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('⑦'),
                                ),
                                FormValue(
                                  workUser7Name,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser7Name,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser7Name = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                FormValue(
                                  workUser7Time,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser7Time,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser7Time = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('⑧'),
                                ),
                                FormValue(
                                  workUser8Name,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser8Name,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser8Name = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                FormValue(
                                  workUser8Time,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser8Time,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser8Time = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Text('清掃'),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('⑨'),
                                ),
                                FormValue(
                                  workUser9Name,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser9Name,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser9Name = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                FormValue(
                                  workUser9Time,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser9Time,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser9Time = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('⑩'),
                                ),
                                FormValue(
                                  workUser10Name,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser10Name,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser10Name = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                FormValue(
                                  workUser10Time,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser10Time,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser10Time = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('⑪'),
                                ),
                                FormValue(
                                  workUser11Name,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser11Name,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser11Name = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                FormValue(
                                  workUser11Time,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser11Time,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser11Time = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Text('警備'),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('⑫'),
                                ),
                                FormValue(
                                  workUser12Name,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser12Name,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser12Name = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                FormValue(
                                  workUser12Time,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser12Time,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser12Time = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('⑬'),
                                ),
                                FormValue(
                                  workUser13Name,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser13Name,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser13Name = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                FormValue(
                                  workUser13Time,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser13Time,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser13Time = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('⑭'),
                                ),
                                FormValue(
                                  workUser14Name,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser14Name,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser14Name = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                FormValue(
                                  workUser14Time,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser14Time,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser14Time = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Text('自転車整理'),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('⑮'),
                                ),
                                FormValue(
                                  workUser15Name,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser15Name,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser15Name = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                FormValue(
                                  workUser15Time,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser15Time,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser15Time = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('⑯'),
                                ),
                                FormValue(
                                  workUser16Name,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser16Name,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser16Name = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                FormValue(
                                  workUser16Time,
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      contentPadding: const EdgeInsets.all(16),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomTextField(
                                            controller: TextEditingController(
                                              text: workUser16Time,
                                            ),
                                            textInputType: TextInputType.text,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              workUser16Time = value;
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '入場者数カウント',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                          },
                          children: [
                            const TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(''),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('12:30'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('20:00'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('22:00'),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('お城下広場'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('いごっそう'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('自由広場'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('東通路(バル)'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('計'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('前年同曜日'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'コインロッカー',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
                            2: IntrinsicColumnWidth(),
                            3: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('連続使用'),
                                ),
                                FormValue(
                                  '無',
                                  onTap: () {},
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('忘れ物'),
                                ),
                                FormValue(
                                  '無',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('回収'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'イベント',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            const TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('主'),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            const TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('周辺'),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '集客',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '取材・視察',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '広場出店',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('使用料'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('入金状況'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '打合せ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'メールチェック',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('10:30'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('12:00'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('18:00'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('22:00'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '警戒',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        const Text('19:45～'),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('状態'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('対処'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text('23:00～'),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('状態'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('対処'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '立替',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('立替'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('現金'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('合計'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '営繕ヶ所等',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '状態',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '対処・修理・結果',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '苦情・要望・問題',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '対処・対応策',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'パンフレット',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              Table(
                border: TableBorder.all(color: kGreyColor),
                columnWidths: const {
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('①'),
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('②'),
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('③'),
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('④'),
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('⑤'),
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('⑥'),
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('⑦'),
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '備品発注・入荷',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              Table(
                border: TableBorder.all(color: kGreyColor),
                columnWidths: const {
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(1),
                  5: FlexColumnWidth(1),
                },
                children: [
                  const TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(''),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('発注／入荷'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('品名'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('業者'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('納期(納入数)'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('発注者'),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('①'),
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('②'),
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('③'),
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('④'),
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('⑤'),
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('⑥'),
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '報告・連絡',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              Table(
                border: TableBorder.all(color: kGreyColor),
                children: [
                  TableRow(
                    children: [
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Table(
                border: TableBorder.all(color: kGreyColor),
                columnWidths: const {
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('日報最終確認'),
                      ),
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '申送り事項',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              Table(
                border: TableBorder.all(color: kGreyColor),
                children: [
                  TableRow(
                    children: [
                      FormValue(
                        '',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '確認',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('最終店舗最終終了時刻'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('食器センター終了'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('排気'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('天井扇SW'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('空調SW'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('トイレ確認'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('ベビーコーナー'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('PC・ゴミ'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('留守電'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('クーポン券確認'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('日付確認'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('両替確認'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'パスポート押印',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          children: [
                            TableRow(
                              children: [
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Table(
                          border: TableBorder.all(color: kGreyColor),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('昨日計'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('本日計'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('合計'),
                                ),
                                FormValue(
                                  '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
