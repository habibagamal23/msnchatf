import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/routes.dart';
import '../../../core/utils/styles.dart';
import '../../register/model/user_info.dart';
import '../model/roomModel.dart';

class UserCard extends StatelessWidget {
  final UserProfile userProfile;
  final Room? room;

  UserCard({required this.userProfile, this.room});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.Chatscreen,
            arguments: {'userProfile': userProfile, 'idroom': room?.id});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: ColorsManager.mainBlue,
              ),
              child: Row(
                children: [
                  _buildAvatar(),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildUserDetails(),
                  ),
                  room?.lastMessage != ''
                      ? Text(
                          Styles.formatLastMessageTime(room!.lastMessageTime),
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            _buildDivider()
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: ColorsManager.whitebeg,
          radius: 30,
          child: Text(
            userProfile.name[0].toUpperCase(),
            style: const TextStyle(
              color: ColorsManager.mainBlue,
              fontSize: 24,
            ),
          ),
        ),
        if (userProfile.online)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userProfile.name,
          style: const TextStyle(
            color: ColorsManager.whitebeg,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        room?.lastMessage != ''
            ? Text(
                room!.lastMessage,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Text(
                userProfile.about,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.only(top: 3),
      height: 1,
      color: Colors.grey.shade300,
    );
  }
}
