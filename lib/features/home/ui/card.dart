import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msnchat/core/utils/routes.dart';
import 'package:msnchat/features/chat/message_cubit.dart';

import '../../../core/utils/styles.dart';
import '../../chat/chatscreen.dart';
import '../model/roomModel.dart';
import '../model/user_info.dart';

class UserCard extends StatelessWidget {
  final UserProfile userProfile;
  final Room room;

  UserCard({required this.userProfile, required this.room});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.chatScreen,
          arguments: userProfile,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: ColorsManager.mainBlue,
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: ColorsManager.whitebeg,
                        radius: 30,
                        child: Text(
                          userProfile.name[0].toUpperCase(),
                          style: TextStyle(
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
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProfile.name,
                        style: TextStyle(
                          color: ColorsManager.whitebeg,
                          fontSize: 20, // Increased font size for the name
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        userProfile.about,
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 3),
              height: 1,
              color:
                  Colors.grey.shade300, // Light grey color for the divider line
            ),
          ],
        ),
      ),
    );
  }
}
