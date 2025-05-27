import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/log.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/services/log.dart';
import 'package:miel_work_web/widgets/log_list.dart';

class LogScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const LogScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  LogService logService = LogService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        title: const Text(
          '操作ログ',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.xmark,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: logService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                ),
                builder: (context, snapshot) {
                  List<LogModel> logs = [];
                  if (snapshot.hasData) {
                    logs = logService.generateList(
                      data: snapshot.data,
                    );
                  }
                  if (logs.isEmpty) {
                    return const Center(
                        child: Text(
                      '操作ログはありません',
                      style: TextStyle(fontSize: 24),
                    ));
                  }
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: kBorderColor),
                    ),
                    child: ListView.builder(
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        LogModel log = logs[index];
                        return LogList(log: log);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
