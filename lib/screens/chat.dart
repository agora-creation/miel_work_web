import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/chat.dart';
import 'package:miel_work_web/models/chat_message.dart';
import 'package:miel_work_web/models/organization_group.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/providers/chat_message.dart';
import 'package:miel_work_web/providers/home.dart';
import 'package:miel_work_web/providers/login.dart';
import 'package:miel_work_web/services/chat.dart';
import 'package:miel_work_web/services/chat_message.dart';
import 'package:miel_work_web/services/user.dart';
import 'package:miel_work_web/widgets/chat_area.dart';
import 'package:miel_work_web/widgets/chat_header.dart';
import 'package:miel_work_web/widgets/chat_list.dart';
import 'package:miel_work_web/widgets/custom_button_sm.dart';
import 'package:miel_work_web/widgets/message_form_field.dart';
import 'package:miel_work_web/widgets/message_list.dart';
import 'package:miel_work_web/widgets/user_list.dart';
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
  UserService userService = UserService();
  List<ChatModel> chats = [];
  ChatModel? currentChat;
  List<UserModel> currentChatUsers = [];

  void _getChats() async {
    OrganizationGroupModel? group = widget.homeProvider.currentGroup;
    chats = await chatService.selectList(
      organizationId: widget.loginProvider.organization?.id,
      groupId: group?.id,
    );
    setState(() {});
  }

  void _currentChatChange(ChatModel chat) async {
    currentChat = chat;
    currentChatUsers = await userService.selectList(
      userIds: chat.userIds,
    );
    List<ChatMessageModel> messages = await messageService.selectList(
      chatId: currentChat?.id,
      user: widget.loginProvider.user,
    );
    if (messages.isNotEmpty) {
      for (ChatMessageModel message in messages) {
        List<String> readUserIds = message.readUserIds;
        readUserIds.add(widget.loginProvider.user?.id ?? '');
        messageService.update({
          'id': message.id,
          'readUserIds': readUserIds,
        });
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getChats();
  }

  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<ChatMessageProvider>(context);
    UserModel? loginUser = widget.loginProvider.user;
    List<String> chatUserIds = currentChat?.userIds ?? [];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: ChatArea(
          chatsView: chats.isNotEmpty
              ? ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    ChatModel chat = chats[index];
                    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: messageService.streamList(
                        chatId: chat.id,
                      ),
                      builder: (context, snapshot) {
                        bool unread = false;
                        if (snapshot.hasData) {
                          unread = messageService.unreadCheck(
                            data: snapshot.data,
                            user: loginUser,
                          );
                        }
                        return ChatList(
                          chat: chat,
                          unread: unread,
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
                        usersOnPressed: () => showDialog(
                          context: context,
                          builder: (context) => ChatUsersDialog(
                            chat: currentChat!,
                            users: currentChatUsers,
                          ),
                        ),
                      ),
                      Expanded(
                        child:
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: messageService.streamList(
                            chatId: currentChat?.id,
                          ),
                          builder: (context, snapshot) {
                            List<ChatMessageModel> messages = [];
                            if (snapshot.hasData) {
                              messages = messageService.generateList(
                                data: snapshot.data,
                              );
                            }
                            if (messages.isEmpty) {
                              return const Center(child: Text('メッセージはありません'));
                            }
                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              reverse: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                ChatMessageModel message = messages[index];
                                return MessageList(
                                  message: message,
                                  isMe: message.createdUserId == loginUser?.id,
                                  onTapImage: () {},
                                );
                              },
                            );
                          },
                        ),
                      ),
                      MessageFormField(
                        controller: messageProvider.contentController,
                        galleryPressed: () async {
                          final result = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          if (result == null) return;
                          String? error = await messageProvider.sendImage(
                            chat: currentChat,
                            loginUser: loginUser,
                            imageXFile: result,
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
                            loginUser: loginUser,
                          );
                          if (error != null) {
                            if (!mounted) return;
                            showMessage(context, error, false);
                            return;
                          }
                        },
                        enabled: chatUserIds.contains(loginUser?.id),
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
    );
  }
}

class ChatUsersDialog extends StatelessWidget {
  final ChatModel chat;
  final List<UserModel> users;

  const ChatUsersDialog({
    required this.chat,
    required this.users,
    super.key,
  });

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
