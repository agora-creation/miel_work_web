import 'package:flutter/material.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/reply_source.dart';

class ReplySourceList extends StatelessWidget {
  final ReplySourceModel? replySource;

  const ReplySourceList({
    required this.replySource,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      child: ListTile(
        title: Text(
          replySource?.createdUserName ?? '',
          style: const TextStyle(fontSize: 16),
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Text(
          replySource?.content ?? '',
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
