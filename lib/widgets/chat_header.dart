import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/chat.dart';

class ChatHeader extends StatelessWidget {
  final ChatModel chat;
  final Function()? searchOnPressed;
  final Function()? usersOnPressed;

  const ChatHeader({
    required this.chat,
    required this.searchOnPressed,
    required this.usersOnPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      decoration: const BoxDecoration(
        color: kWhiteColor,
        border: Border(bottom: BorderSide(color: kGreyColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(chat.name),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  FluentIcons.search,
                  color: kBlueColor,
                  size: 18,
                ),
                onPressed: searchOnPressed,
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(
                  FluentIcons.group,
                  color: kBlueColor,
                  size: 18,
                ),
                onPressed: usersOnPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
