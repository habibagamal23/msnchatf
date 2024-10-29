import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../features/chat/model/message_model.dart';
import '../../features/home/model/roomModel.dart';
import '../../features/home/model/user_info.dart';
import 'notifcations.dart';

class FireBaseData {
  final FirebaseFirestore _firestor = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  String get myUid => _firebaseAuth.currentUser!.uid;

  // 1-  update user push token in Firestore
  Future<void> updateUserToken(String userId) async {
    String? token = await Nofifcation().getDevicesToken();
    if (token != null) {
      await _firestor.collection('users').doc(userId).update({
        'push_token': token,
      });
    }
  }

  // 2-  add when create user push token  for each user
  Future creatUser(UserProfile userprofil) async {
    try {
      userprofil.pushToken = await Nofifcation().getDevicesToken() ?? "";
      await _firestor
          .collection('users')
          .doc(userprofil.id)
          .set(userprofil.toJson());
      print("User secces created with push token ");
    } catch (e) {
      print("error when you created user $e");
    }
  }

  Stream<List<UserProfile>> getAllUsers() {
    return _firestor.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserProfile.fromJson(doc.data()))
          .toList();
    });
  }

  Stream<List<UserProfile>> getAllUsersWithoutme() {
    return _firestor.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserProfile.fromJson(doc.data()))
          .where((user) => user.id != myUid)
          .toList();
    });
  }

  Future createRoom(String userId) async {
    try {
      CollectionReference chatroom = await _firestor.collection('rooms');
      final sortedmemers = [myUid, userId]..sort((a, b) => a.compareTo(b));
      QuerySnapshot existChatrooom =
          await chatroom.where('members', isEqualTo: sortedmemers).get();
      if (existChatrooom.docs.isNotEmpty) {
        return existChatrooom.docs.first.id;
      } else {
        final chatroomid = await _firestor.collection('rooms').doc().id;
        Room c = Room(
          id: chatroomid,
          createdAt: DateTime.now().toIso8601String(),
          lastMessage: "",
          members: sortedmemers,
          lastMessageTime: DateTime.now().toIso8601String(),
        );
        await _firestor.collection('rooms').doc(chatroomid).set(c.toJson());
      }
    } catch (e) {
      return e.toString();
    }
  }

  Stream<List<Room>> getAllRooms() {
    return _firestor
        .collection('rooms')
        .where('members', arrayContains: myUid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Room.fromJson(doc.data())).toList()
              ..sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime)));
  }

// 3- when i send message i send also notifction for this user
  Future createMessage(
      String toid, String msg, String roomid, String type) async {
    final msgid = _firestor.collection('messages').doc().id;

    Message message = Message(
        id: msgid,
        toId: toid,
        fromId: myUid,
        msg: msg,
        read: false,
        createdAt: DateTime.now().toIso8601String(),
        type: type);

    DocumentReference myroom = _firestor.collection('rooms').doc(roomid);

    await myroom.collection('messages').doc(msgid).set(message.toJson());

    await myroom.update(
        {'last_message': message.msg, 'last_message_time': message.createdAt});

    DocumentSnapshot user =
        await _firestor.collection('users').doc(message.toId).get();
    String pushtokent = user.get('push_token');
    String username = user.get('name');

    if (pushtokent != null && pushtokent.isNotEmpty) {
      await Nofifcation().senNotifaction(message.msg, username, pushtokent);
    }
  }

  Stream<List<Message>> getMessages(String roomid) {
    return _firestor
        .collection('rooms')
        .doc(roomid)
        .collection('messages')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }

  Future imageSorge(File file, String roomid) async {
    String ext = file.path.split('.').last;
    // this is path
    final ref = firebaseStorage.ref().child('images/$roomid/'
        '${DateTime.now().microsecondsSinceEpoch}.$ext');

    await ref.putFile(file);

    return await ref.getDownloadURL();
  }
}
