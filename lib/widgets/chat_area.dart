import 'package:flutter/material.dart';
import 'package:miel_work_web/common/style.dart';

class ChatArea extends StatelessWidget {
  final Widget chatsView;
  final Widget messageView;

  const ChatArea({
    required this.chatsView,
    required this.messageView,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kBorderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 300,
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: kBorderColor)),
            ),
            child: chatsView,
          ),
          Expanded(child: messageView),
        ],
      ),
    );
  }
}
