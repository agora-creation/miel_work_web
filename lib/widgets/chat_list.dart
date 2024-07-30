import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/chat.dart';

class ChatList extends StatelessWidget {
  final ChatModel chat;
  final int unreadCount;
  final bool selected;
  final Function()? onTap;

  const ChatList({
    required this.chat,
    required this.unreadCount,
    required this.selected,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? kGreyColor.withOpacity(0.3) : null,
          border: Border(bottom: BorderSide(color: kBorderColor)),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${chat.name} (${chat.userIds.length})',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    chat.lastMessage,
                    style: const TextStyle(
                      color: kBlackColor,
                      fontSize: 12,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            unreadCount > 0
                ? Badge(
                    label: Text(unreadCount.toString()),
                    backgroundColor: kRedColor,
                  )
                : const FaIcon(
                    color: kDisabledColor,
                    FontAwesomeIcons.chevronRight,
                    size: 12,
                  ),
          ],
        ),
      ),
    );
  }
}
