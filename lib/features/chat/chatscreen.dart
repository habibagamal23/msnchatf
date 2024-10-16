import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:msnchat/core/utils/styles.dart';
import 'package:msnchat/features/chat/message_cubit.dart';

import '../../../core/network_services/fireBase_data.dart';
import '../home/model/user_info.dart';
import 'message_model.dart';

class ChatScreen extends StatelessWidget {
  final UserProfile userProfile;

  ChatScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          children: [
           Expanded(child: Container()),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: TextField(
                    maxLines: 5,
                      minLines: 1,
                      decoration: InputDecoration(
                        suffixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
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
                  onPressed: (){},
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
                Text(messageItem.msg),
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
