import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/home/model/roomModel.dart';
import '../../features/register/model/user_info.dart';

class FireBaseData {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String get myUid => _auth.currentUser!.uid;
  Future<void> createUserProfile(UserProfile userProfile) async {
    try {
      await _firestore
          .collection('users')
          .doc(userProfile.id)
          .set(userProfile.toJson());
      print('User profile created successfully!');
    } catch (e) {
      print('Error creating user profile: $e');
    }
  }

  Stream<List<UserProfile>> fetchAllUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map(
              (doc) => UserProfile.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<List<UserProfile>> fetchAllUsersWithoutme() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map(
              (doc) => UserProfile.fromJson(doc.data() as Map<String, dynamic>))
          .where((user) => user.id != myUid) // Exclude the current user
          .toList();
    });
  }

  Future<String> createRoom(String userId) async {
    try {
      CollectionReference chatrooms =
      FirebaseFirestore.instance.collection('rooms');

      final sortedMembers = [myUid, userId]..sort((a, b) => a.compareTo(b));

      QuerySnapshot existingChatrooms = await chatrooms
          .where(
        'members',
        isEqualTo: sortedMembers,
      )
          .get();

      if (existingChatrooms.docs.isNotEmpty) {
        return existingChatrooms.docs.first.id;
      } else {
        final chatroomId =
            _firestore.collection('rooms').doc().id; // Generate a unique ID

        Room c = Room(
          id: chatroomId,
          createdAt: DateTime.now().toIso8601String(),
          lastMessage: "",
          lastMessageTime: DateTime.now().toIso8601String(),
          members: sortedMembers,
        );

        await FirebaseFirestore.instance
            .collection("rooms")
            .doc(chatroomId)
            .set(c.toJson());

        return chatroomId;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Stream<List<Room>> getAllChats() {
    return _firestore
        .collection('rooms')
        .where('members', arrayContains: myUid)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Room.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }
}
