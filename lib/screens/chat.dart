import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/chat.dart';
import 'package:miel_work_web/models/chat_message.dart';
import 'package:miel_work_web/models/read_user.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/chat_message.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/services/chat.dart';
import 'package:miel_work_web/services/chat_message.dart';
import 'package:miel_work_web/services/user.dart';
import 'package:miel_work_web/widgets/animation_background.dart';
import 'package:miel_work_web/widgets/chat_area.dart';
import 'package:miel_work_web/widgets/chat_header.dart';
import 'package:miel_work_web/widgets/chat_list.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/custom_text_box.dart';
import 'package:miel_work_web/widgets/message_form_field.dart';
import 'package:miel_work_web/widgets/message_list.dart';
import 'package:miel_work_web/widgets/read_user_list.dart';
import 'package:miel_work_web/widgets/user_list.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ChatScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatService chatService = ChatService();
  ChatMessageService messageService = ChatMessageService();
  List<ChatModel> chats = [];
  ChatModel? currentChat;
  String searchKeyword = '';

  void _getKeyword() async {
    searchKeyword = await getPrefsString('keyword') ?? '';
    setState(() {});
  }

  void _getChats() async {
    chats = await chatService.selectList(
      organizationId: widget.loginProvider.organization?.id,
      groupId: widget.homeProvider.currentGroup?.id,
    );
    setState(() {});
  }

  void _currentChatChange(ChatModel chat) async {
    currentChat = chat;
    await messageService.updateRead(
      chatId: chat.id,
      loginUser: widget.loginProvider.user,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getChats();
    _getKeyword();
  }

  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<ChatMessageProvider>(context);
    List<String> currentChatUserIds = currentChat?.userIds ?? [];
    return Stack(
      children: [
        const AnimationBackground(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: ChatArea(
              chatsView: chats.isNotEmpty
                  ? ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        ChatModel chat = chats[index];
                        return StreamBuilder<
                            QuerySnapshot<Map<String, dynamic>>>(
                          stream: messageService.streamList(chatId: chat.id),
                          builder: (context, snapshot) {
                            List<ChatMessageModel> messages = [];
                            if (snapshot.hasData) {
                              messages = messageService.generateListUnread(
                                data: snapshot.data,
                                loginUser: widget.loginProvider.user,
                              );
                            }
                            return ChatList(
                              chat: chat,
                              unreadCount: messages.length,
                              selected: currentChat == chat,
                              onTap: () => _currentChatChange(chat),
                            );
                          },
                        );
                      },
                    )
                  : const Center(child: Text('チャットルームはありません')),
              messageView: currentChat != null
                  ? Container(
                      color: kGrey200Color,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ChatHeader(
                            chat: currentChat!,
                            searchOnPressed: () => showDialog(
                              context: context,
                              builder: (context) => SearchKeywordDialog(
                                getKeyword: _getKeyword,
                              ),
                            ),
                            usersOnPressed: () => showDialog(
                              context: context,
                              builder: (context) => ChatUsersDialog(
                                chat: currentChat!,
                              ),
                            ),
                          ),
                          Expanded(
                            child: StreamBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                              stream: messageService.streamList(
                                chatId: currentChat?.id,
                              ),
                              builder: (context, snapshot) {
                                List<ChatMessageModel> messages = [];
                                if (snapshot.hasData) {
                                  messages = messageService.generateListKeyword(
                                    data: snapshot.data,
                                    keyword: searchKeyword,
                                  );
                                }
                                if (messages.isEmpty) {
                                  return const Center(
                                      child: Text('メッセージはありません'));
                                }
                                return ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  shrinkWrap: true,
                                  reverse: true,
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    ChatMessageModel message = messages[index];
                                    return MessageList(
                                      message: message,
                                      isMe: message.createdUserId ==
                                          widget.loginProvider.user?.id,
                                      onTapReadUsers: () => showDialog(
                                        context: context,
                                        builder: (context) => ReadUsersDialog(
                                          readUsers: message.readUsers,
                                        ),
                                      ),
                                      onTapImage: () {
                                        File file = File(message.image);
                                        downloadFile(
                                          url: message.image,
                                          name: p.basename(file.path),
                                        );
                                      },
                                      onTapFile: () {
                                        File file = File(message.file);
                                        downloadFile(
                                          url: message.file,
                                          name: p.basename(file.path),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          MessageFormField(
                            controller: messageProvider.contentController,
                            filePressed: () {},
                            galleryPressed: () async {
                              final result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.image,
                              );
                              String? error = await messageProvider.sendImage(
                                chat: currentChat,
                                loginUser: widget.loginProvider.user,
                                result: result,
                              );
                              if (error != null) {
                                if (!mounted) return;
                                showMessage(context, error, false);
                                return;
                              }
                            },
                            sendPressed: () async {
                              String? error = await messageProvider.send(
                                chat: currentChat,
                                loginUser: widget.loginProvider.user,
                              );
                              if (error != null) {
                                if (!mounted) return;
                                showMessage(context, error, false);
                                return;
                              }
                            },
                            enabled: currentChatUserIds
                                .contains(widget.loginProvider.user?.id),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      color: kGrey200Color,
                      child: const Center(
                        child: Text('左側のチャットルームを選択してください'),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class SearchKeywordDialog extends StatefulWidget {
  final Function() getKeyword;

  const SearchKeywordDialog({
    required this.getKeyword,
    super.key,
  });

  @override
  State<SearchKeywordDialog> createState() => _SearchKeywordDialogState();
}

class _SearchKeywordDialogState extends State<SearchKeywordDialog> {
  TextEditingController keywordController = TextEditingController();

  void _getKeyword() async {
    keywordController = TextEditingController(
      text: await getPrefsString('keyword') ?? '',
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getKeyword();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'キーワード検索',
        style: TextStyle(fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextBox(
              controller: keywordController,
              placeholder: '',
              keyboardType: TextInputType.text,
              maxLines: 1,
            ),
          ],
        ),
      ),
      actions: [
        CustomButtonSm(
          labelText: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButtonSm(
          labelText: '検索する',
          labelColor: kWhiteColor,
          backgroundColor: kLightBlueColor,
          onPressed: () async {
            await setPrefsString('keyword', keywordController.text);
            widget.getKeyword();
            if (!mounted) return;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ChatUsersDialog extends StatefulWidget {
  final ChatModel chat;

  const ChatUsersDialog({
    required this.chat,
    super.key,
  });

  @override
  State<ChatUsersDialog> createState() => _ChatUsersDialogState();
}

class _ChatUsersDialogState extends State<ChatUsersDialog> {
  UserService userService = UserService();
  List<UserModel> users = [];

  void _init() async {
    users = await userService.selectList(
      userIds: widget.chat.userIds,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        '参加スタッフ',
        style: TextStyle(fontSize: 18),
      ),
      content: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kGrey300Color),
        ),
        height: 300,
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            UserModel user = users[index];
            return UserList(user: user);
          },
        ),
      ),
      actions: [
        CustomButtonSm(
          labelText: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class ReadUsersDialog extends StatefulWidget {
  final List<ReadUserModel> readUsers;

  const ReadUsersDialog({
    required this.readUsers,
    super.key,
  });

  @override
  State<ReadUsersDialog> createState() => _ReadUsersDialogState();
}

class _ReadUsersDialogState extends State<ReadUsersDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        '既読スタッフ',
        style: TextStyle(fontSize: 18),
      ),
      content: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kGrey300Color),
        ),
        height: 300,
        child: ListView.builder(
          itemCount: widget.readUsers.length,
          itemBuilder: (context, index) {
            ReadUserModel readUser = widget.readUsers[index];
            return ReadUserList(readUser: readUser);
          },
        ),
      ),
      actions: [
        CustomButtonSm(
          labelText: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
