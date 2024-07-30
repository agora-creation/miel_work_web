import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/chat.dart';
import 'package:miel_work_web/models/reply_source.dart';
import 'package:miel_work_web/providers/chat_message.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/widgets/custom_button.dart';
import 'package:miel_work_web/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class ChatMessageScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final ChatModel? currentChat;

  const ChatMessageScreen({
    required this.loginProvider,
    this.currentChat,
    super.key,
  });

  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  TextEditingController contentController = TextEditingController();
  ReplySourceModel? replySource;

  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<ChatMessageProvider>(context);
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
        actions: [
          CustomButton(
            type: ButtonSizeType.sm,
            label: '以下の内容で送信する',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () async {
              String? error = await messageProvider.send(
                chat: widget.currentChat,
                loginUser: widget.loginProvider.user,
                content: contentController.text,
                replySource: replySource,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, 'メッセージが送信されました', true);
              Navigator.pop(context);
            },
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: contentController,
                textInputType: TextInputType.multiline,
                maxLines: 30,
                hintText: 'メッセージを入力...',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
