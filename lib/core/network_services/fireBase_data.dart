import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
}
