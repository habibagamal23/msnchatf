import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

    final sortmember = [myUid , userId]..sort((a,b)=>a.compareTo(b));



    CollectionReference chatroom =await _firestor.collection('rooms');
    QuerySnapshot existroom = await chatroom.where('members', isEqualTo: sortmember).get();

    if(existroom.docs.isNotEmpty){
      return existroom.docs.first.id;
    }else {
      String chatroomid = _firestor.collection('rooms').doc().id;
      try {
        Room r = Room(
            id: chatroomid,
            createdAt: DateTime.now().toIso8601String(),
            lastMessage: "",
            members: sortmember,
            lastMessageTime: DateTime.now().toIso8601String());

        await _firestor.collection('rooms').doc(chatroomid).set(r.toJson());
      } catch (e) {
        print(e.toString());
      }
    }


  }

  Stream<List<Room>> getAllRooms() {
    return _firestor
        .collection('rooms')
        .where('members', arrayContains: myUid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Room.fromJson(doc.data())).toList());
  }
}
