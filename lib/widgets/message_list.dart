import 'package:flutter/material.dart';
import 'package:miel_work_web/common/functions.dart';
import 'package:miel_work_web/common/style.dart';
import 'package:miel_work_web/models/chat_message.dart';
import 'package:miel_work_web/models/read_user.dart';
import 'package:miel_work_web/models/user.dart';
import 'package:miel_work_web/widgets/favorite_icon.dart';
import 'package:miel_work_web/widgets/link_text.dart';

class MessageList extends StatelessWidget {
  final ChatMessageModel message;
  final UserModel? loginUser;
  final Function()? onTapReadUsers;
  final Function()? onTapImage;
  final Function()? onTapFile;
  final Function()? onTapDelete;

  const MessageList({
    required this.message,
    required this.loginUser,
    required this.onTapReadUsers,
    required this.onTapImage,
    required this.onTapFile,
    required this.onTapDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<ReadUserModel> readUsers = [];
    for (ReadUserModel readUser in message.readUsers) {
      if (readUser.userId != loginUser?.id) {
        readUsers.add(readUser);
      }
    }
    if (message.createdUserId == loginUser?.id) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            message.image == '' && message.file == ''
                ? Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    color: kYellowColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        message.replySource != null
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message.replySource
                                                  ?.createdUserName ??
                                              '',
                                          style: const TextStyle(
                                            color: kGrey600Color,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          message.replySource?.content ?? '',
                                          style: const TextStyle(
                                            color: kGrey600Color,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(color: kWhiteColor, height: 1),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      message.content,
                                    ).urlToLink(context),
                                  ),
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                child: Text(
                                  message.content,
                                ).urlToLink(context),
                              ),
                        FavoriteIcon(message.favoriteUserIds),
                      ],
                    ),
                  )
                : Container(),
            message.image != ''
                ? GestureDetector(
                    onTap: onTapImage,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      color: kYellowColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          message.image,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : Container(),
            message.file != ''
                ? GestureDetector(
                    onTap: onTapFile,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      color: kYellowColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.file_open),
                              const SizedBox(height: 4),
                              Text('${message.id}${message.fileExt}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            Text(
              dateText('MM/dd HH:mm', message.createdAt),
              style: const TextStyle(
                color: kGreyColor,
                fontSize: 12,
              ),
            ),
            readUsers.isNotEmpty
                ? GestureDetector(
                    onTap: onTapReadUsers,
                    child: Text(
                      '既読 ${readUsers.length}',
                      style: const TextStyle(
                        color: kGrey600Color,
                        fontSize: 12,
                      ),
                    ),
                  )
                : Container(),
            LinkText(
              label: '削除する',
              color: kRedColor,
              onTap: onTapDelete,
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.createdUserName,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 2),
            message.image == '' && message.file == ''
                ? Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    color: kWhiteColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        message.replySource != null
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message.replySource
                                                  ?.createdUserName ??
                                              '',
                                          style: const TextStyle(
                                            color: kGrey600Color,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          message.replySource?.content ?? '',
                                          style: const TextStyle(
                                            color: kGrey600Color,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                      color: kGrey200Color, height: 1),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      message.content,
                                    ).urlToLink(context),
                                  ),
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                child: Text(
                                  message.content,
                                ).urlToLink(context),
                              ),
                        FavoriteIcon(message.favoriteUserIds),
                      ],
                    ),
                  )
                : Container(),
            message.image != ''
                ? GestureDetector(
                    onTap: onTapImage,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      color: kWhiteColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          message.image,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : Container(),
            message.file != ''
                ? GestureDetector(
                    onTap: onTapFile,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      color: kWhiteColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.file_open),
                              const SizedBox(height: 4),
                              Text('${message.id}${message.fileExt}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            Text(
              dateText('MM/dd HH:mm', message.createdAt),
              style: const TextStyle(
                color: kGreyColor,
                fontSize: 12,
              ),
            ),
            readUsers.isNotEmpty
                ? GestureDetector(
                    onTap: onTapReadUsers,
                    child: Text(
                      '既読 ${readUsers.length}',
                      style: const TextStyle(
                        color: kGrey600Color,
                        fontSize: 12,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      );
    }
  }
}
