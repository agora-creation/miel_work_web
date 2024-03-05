import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/chat.dart';

class ChatList extends StatelessWidget {
  final ChatModel chat;
  final bool unread;
  final bool selected;
  final Function()? onTap;

  const ChatList({
    required this.chat,
    required this.unread,
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
          color: selected ? kGrey200Color : null,
          border: const Border(
            bottom: BorderSide(color: kGreyColor),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${chat.name} (${chat.userIds.length})',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  chat.lastMessage,
                  style: const TextStyle(
                    color: kGreyColor,
                    fontSize: 12,
                  ),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
            unread
                ? const Icon(
                    FluentIcons.circle_fill,
                    color: kRedColor,
                    size: 16,
                  )
                : const Icon(
                    FluentIcons.chevron_right,
                    size: 12,
                  ),
          ],
        ),
      ),
    );
  }
}
