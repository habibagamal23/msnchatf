import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:msnchat/core/utils/styles.dart';
import 'package:msnchat/features/chat/loggic/messages_cubit.dart';

import '../../../../core/network_services/fireBase_data.dart';
import '../../home/model/user_info.dart';
import '../model/message_model.dart';

class ChatScreen extends StatelessWidget {
  final UserProfile userProfile;

  ChatScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userProfile.name,
              style: const TextStyle(
                color: ColorsManager.mainBlue,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Last Seen ${Styles.getLastActiveTime(userProfile.lastActivated)}",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.accessibility_new_outlined,
                color: ColorsManager.mainBlue),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          children: [
            Expanded(child: BlocBuilder<MessagesCubit, MessagesState>(
                builder: (context, state) {
              if (state is MessagesLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is MessagesSuccess) {
                return ListView.builder(
                    reverse: true,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final meg = state.messages[index];
                      bool isme = meg.fromId == FireBaseData().myUid;
                      return Align(
                        alignment:
                            isme ? Alignment.centerRight : Alignment.centerLeft,
                        child: Card(
                          margin: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft:
                                  isme ? Radius.circular(16) : Radius.zero,
                              bottomRight:
                                  isme ? Radius.zero : Radius.circular(16),
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          color: isme
                              ? ColorsManager.blue2
                              : ColorsManager.lightblue,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                meg.type == "text"
                                    ? Text(meg.msg)
                                    : Image.network(
                                        meg.msg,
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(DateFormat.jm()
                                    .format(DateTime.parse(meg.createdAt))),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }
              if (state is MessagesError) {
                return Center(
                  child: Text(state.error),
                );
              }
              return Center(
                child: Text("get start"),
              );
            })),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: TextField(
                      controller:
                          context.read<MessagesCubit>().messageContrller,
                      maxLines: 5,
                      minLines: 1,
                      decoration: InputDecoration(
                        suffixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? photo = await picker.pickImage(
                                    source: ImageSource.camera);

                                if (photo != null) {
                                  File file = File(photo.path);
                                  await context
                                      .read<MessagesCubit>()
                                      .sendImage(file, userProfile.id);
                                }
                              },
                              icon: const Icon(Icons.camera),
                            ),
                          ],
                        ),
                        border: InputBorder.none,
                        hintText: "Message",
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final mes =
                        context.read<MessagesCubit>().messageContrller.text;
                    if (mes.isNotEmpty) {
                      context
                          .read<MessagesCubit>()
                          .sendMessage(userProfile.id, "text");
                    }
                    context.read<MessagesCubit>().messageContrller.clear();
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userProfile.name,
            style: const TextStyle(
              color: ColorsManager.mainBlue,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Text(
          //   "Last Seen ${Styles.getLastActiveTime(userProfile.lastActivated)}",
          //   style: Theme.of(context).textTheme.labelLarge,
          // ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.accessibility_new_outlined,
              color: ColorsManager.mainBlue),
        ),
      ],
    );
  }
}

class ChatMessageCard extends StatelessWidget {
  final Message messageItem;

  ChatMessageCard({required this.messageItem});

  @override
  Widget build(BuildContext context) {
    final bool isMe = messageItem.fromId == FireBaseData().myUid;

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
              bottomRight: isMe ? Radius.zero : const Radius.circular(16),
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
            ),
          ),
          color: isMe ? ColorsManager.blue2 : ColorsManager.lightblue,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (messageItem.type == 'text') ...[
                  Text(messageItem.msg),
                ] else if (messageItem.type == 'image') ...[
                  Image.network(
                    messageItem.msg,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ],
                const SizedBox(height: 5),
                Text(
                  DateFormat.jm().format(
                    DateTime.parse(messageItem.createdAt),
                  ),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
