import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/chat/model/massegemodel.dart';
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
          .where((user) => user.id != myUid)
          .toList();
    });
  }

  Future<String> createRoom(String userId) async {
    try {
      final sortedMembers = [myUid, userId]..sort((a, b) => a.compareTo(b));

      CollectionReference chatrooms =
          FirebaseFirestore.instance.collection('rooms');
      QuerySnapshot existingChatrooms = await chatrooms
          .where(
            'members',
            isEqualTo: sortedMembers,
          )
          .get();

      if (existingChatrooms.docs.isNotEmpty) {
        return existingChatrooms.docs.first.id;
      } else {
        final chatroomId = _firestore.collection('rooms').doc().id;

        Room r = Room(
          id: chatroomId,
          createdAt: DateTime.now().toIso8601String(),
          lastMessage: "",
          lastMessageTime: DateTime.now().toIso8601String(),
          members: sortedMembers,
        );

        await FirebaseFirestore.instance
            .collection("rooms")
            .doc(chatroomId)
            .set(r.toJson());

        return chatroomId;
      }
    } catch (e) {
      return e.toString();
    }
  }

  // to understand create room {

  //List<String> members =
  // [myUid, userId].sort((a, b) => a.compareTo(b));

  //        final chatroomId =
  //        _firestore.collection('rooms').doc().id;

  //1 just creeate
  //ChatRoom chatRoom = ChatRoom(
  //   id: members.toString(),
  //   createdAt: DateTime.now().toString(),
  //   lastMessage: "",
  //   lastMessageTime: DateTime.now().toString(),
  //   members: members,
  // );
  // await FirebaseFirestore.instance
  //     .collection("rooms")
  //     .doc(chatroomId)
  //     .set(c.toJson());
  //
  //to ckeck
  // if it exist not creat and it
  // again:to just get my rooms on;y

  // CollectionReference chatrooms =
  //      ;
  //
  // QuerySnapshot existingChatrooms = await  _firestoree.collection('rooms')
  //           .where(
  //             'members',
  //             isEqualTo: sortedMembers,
  //           )
  //           .get();

  // to just get my rooms on;y
  // QuerySnapshot existingChatrooms = await chatrooms
  //     .where(
  // 'members',
  // isEqualTo: sortedMembers,
  // )
  //     .get();

  // }

  Stream<List<Room>> getAllChats() {
    return _firestore
        .collection('rooms')
        .where('members', arrayContains: myUid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Room.fromJson(doc.data())).toList()
              ..sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime)));
    // sort by last massage
  }

  Future sendMessage(String toid, String msg, String roomId) async {
    final msgId = _firestore.collection('messages').doc().id;
    Message message = Message(
      id: msgId,
      toId: toid,
      fromId: myUid,
      msg: msg,
      type: 'text',
      createdAt: DateTime.now().toString(),
      read: false,
    );

    DocumentReference myChatroomRef =
        _firestore.collection('rooms').doc(roomId);

    await myChatroomRef.collection('messages').doc(msgId).set(message.toJson());

    await myChatroomRef.update({
      'last_message': message.msg,
      'last_message_time': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Stream<List<Message>> getMessages(String roomId) {
    return _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromJson(doc.data());
      }).toList();
    });
  }

  Future<String?> seenMessage({
    required String chatroomId,
    required String messageId,
  }) async {
    await _firestore
        .collection('rooms')
        .doc(chatroomId)
        .collection('masseges')
        .doc(messageId)
        .update({
      'read': true,
    });
    return null;
  }

  Future<void> updateUserOfflineStatus() async {
    try {
      await _firestore.collection('users').doc(myUid).update({
        'online': false,
        'lastActivated': DateTime.now().toIso8601String(),
      });
      print('User online status updated to offline');
    } catch (e) {
      print('Error updating online status: $e');
    }
  }

  Future<void> updateUserLastActivated() async {
    try {
      await _firestore.collection('users').doc(myUid).update({
        'online': true,
        'lastActivated': DateTime.now().toIso8601String(),
      });
      print('User last activated time updated successfully!');
    } catch (e) {
      print('Error updating last activated time: $e');
    }
  }
}
