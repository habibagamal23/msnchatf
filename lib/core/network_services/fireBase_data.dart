import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../features/chat/message_model.dart';
import '../../features/home/model/roomModel.dart';
import '../../features/home/model/user_info.dart';

class FireBaseData {
  final FirebaseFirestore _firestor = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String get myUid => _firebaseAuth.currentUser!.uid;

  Future creatUser(UserProfile userprofil) async {
    try {
      await _firestor
          .collection('users')
          .doc(userprofil.id)
          .set(userprofil.toJson());
      print("User secces created ");
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
//change
  Future createMessage(String toid, String msg, String roomId ,  {required String type}) async {
    final msgId = _firestor.collection('messages').doc().id;
    Message message = Message(
      id: msgId,
      toId: toid,
      fromId: myUid,
      msg: msg,
      type: type,
      createdAt: DateTime.now().toString(),
      read: false,
    );

    DocumentReference myChatroomRef = _firestor.collection('rooms').doc(roomId);

    await myChatroomRef.collection('messages').doc(msgId).set(message.toJson());

    await myChatroomRef.update({
      'last_message': message.msg,
      'last_message_time': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Stream<List<Message>> getMessages(String roomId) {
    return _firestor
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }
/////
  Future<void> updateUserOfflineStatus() async {
    try {
      await _firestor.collection('users').doc(myUid).update({
        'online': false,
        'last_activated': DateTime.now().toIso8601String(),
      });
      print('User online status updated to offline');
    } catch (e) {
      print('Error updating online status: $e');
    }
  }


///
  Future<void> updateUserLastActivated() async {
    try {
      await _firestor.collection('users').doc(myUid).update({
        'online': true,
        'last_activated': DateTime.now().toIso8601String(),
      });
      print('User last activated time updated successfully!');
    } catch (e) {
      print('Error updating last activated time: $e');
    }
  }


  /// storage
///
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadImage(File file, String roomId) async {
    String ext = file.path.split('.').last;
    print("firestorgae");
    final ref = _firebaseStorage
        .ref()
        .child('images/$roomId/${DateTime.now().millisecondsSinceEpoch}.$ext');

    await ref.putFile(file);
    print("image path : ${ref.getDownloadURL()}");
    return await ref.getDownloadURL();
  }
}
