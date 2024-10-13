import 'package:flutter/material.dart';

import '../../../core/utils/styles.dart';
import '../model/user_info.dart';

class UserCard extends StatelessWidget {
  final UserProfile userProfile;

  UserCard({required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15), // Padding inside the card
            decoration: BoxDecoration(
              color: ColorsManager.mainBlue, // Light grey background color
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor:  ColorsManager.whitebeg,
                      radius: 30,
                      // Increased size of the profile picture
                      child: Text(
                        userProfile.name[0].toUpperCase(),
                        style: TextStyle(
                          color: ColorsManager.mainBlue ,
                          fontSize: 24, // Larger font size for the initial
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
                            color: Colors.green, // Online indicator color
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  Colors.white, // White border around the dot
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 15), // Spacing between avatar and text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProfile.name,
                      style: TextStyle(
                        color: ColorsManager.whitebeg ,
                        fontSize: 20, // Increased font size for the name
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                        height:
                            6), // Increased spacing between name and about
                    Text(
                      userProfile.about,
                      style: TextStyle(
                        color: Colors
                            .grey[400], // Subtle grey color for "about"
                        fontSize: 15,
                        fontWeight: FontWeight.w600// Font size for "about" text
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 3),
            height: 1,
            color: Colors.grey.shade300, // Light grey color for the divider line
          ),
        ],
      ),
    );
  }
}
