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
}
