import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/style.dart';

class ChatRoomArea extends StatelessWidget {
  final Widget chatsView;
  final Widget messageView;

  const ChatRoomArea({
    required this.chatsView,
    required this.messageView,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kGreyColor),
      ),
      child: Row(
        children: [
          Container(
            width: 300,
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: kGreyColor)),
            ),
            child: chatsView,
          ),
          Expanded(child: messageView),
        ],
      ),
    );
  }
}
