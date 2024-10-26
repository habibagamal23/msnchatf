import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../features/chat/model/message_model.dart';
import '../../features/home/model/roomModel.dart';
import '../../features/home/model/user_info.dart';
import 'dart:convert'; // For encoding/decoding JSON.
import 'package:http/http.dart' as http; // For HTTP requests.
import 'package:googleapis_auth/auth_io.dart' as auth; // For Google Auth.
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class FireBaseData {
  final FirebaseFirestore _firestor = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String get myUid => _firebaseAuth.currentUser!.uid;

  FireBaseData() {
    // Listen for token changes whenever a new instance of FireBaseData is created
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      if (_firebaseAuth.currentUser != null) {
        print("Token refreshed: $newToken");
        await updateUserToken(_firebaseAuth.currentUser!.uid);
      }
    });
  }

  // Function to obtain access token for FCM
  static Future<String> getAccessToken() async {
    final Map<String, String> serviceAccountJson = {
      "type": "service_account",
      "project_id": "msnchat-bd802",
      "private_key_id": "e3dcb88a9f36489b317fc936f058c6d4e9f5200e",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC+Gpr208EDpAYU\ngbEzMQ0+TkMb54Q2cmitY31mLZJqSFh7hfaFeCN1hV5CYBG8umV+eG10OtMbVXmd\nX0x6CcK5vVN3k+UHuewssgoZBQier0TTmyWEuKzk6PbassaNPJswmumbwvl0DvQE\nNFG2a9lJK/IizQSf8D8UFxVtyqPaJ+IlyQhPu/DfS67nFUOCmFCSOuCa/LWzH7fT\nJHJ+RnzQmBYJIgZnpeW+XeWE25t28M1udYY1Zltce9x/j5VA3bfs8R7IFkEtk3rr\n58gEYdgeDby33qf3/ia6GqKMbTmOSAzuBa+f8z5TNo7lcVt0JnsX0zqFI4cNfiDA\n/dJFeEMJAgMBAAECggEAE0sBsFxd9bPBKrZdUJXRM2IvsR6qRjjO+w7SaIrmNbtd\nIH8gXVwLlDcacXfMwQe1OnQ4HoBEUb03XBNygF2qeZ13Yba8mw/BQml4uSCPxwQA\nYw3XLUytPkeO2vPjDu0oTlLgc76CQMcuOFmDc/UmzoRjXOkL57vy+OPdWMDEp4Rx\nEgF4C5l+uZOuif3w9DIM+0FRjfQapPHeCYOQc7A7WrSRnc9dgIkDNcGkjnydqxqG\ni/sQez+Y0WB/uOiqm6D6siYd0xJOa3Ph3U0ZS8ShtZ5z03B3heLVkpfJbM4UQkM1\nk0OZ5JzvcjiqDZqO9ufh7drfM/UPnFKECiWPv5Gz4QKBgQDrURTVpeUy7QLBIHkH\neRMewZFfwrNeBQcmxm2+iI4ToW//D+COvoUJ63ku9Hq+YjHoVz7cfTzYtjPtdT7s\nL+MoNS/r47ifybCTzUe906IizEH1DPgHyULhjsuB0gC7k7jXFnoKL29m8AYf9r74\nLPiEijA3dQTY3O/x33c0ia7oqQKBgQDO0C4KPKlCOSXnTEzhYkDdG05kGNUdO0Vi\nPvQMGyUA0SEQBq8+F+4a+GSUEntAgE11uae35733rbY1M3SL7/6YWpLOJcdgYXRl\nblkyGsYlhF2DiQmzcBjuhaA3I+A5NCVmD55E7E80Udcrfi6ncdnuk6YZOaZUfmzF\nDVBKvCsjYQKBgQClZpN/bKECv6dM+jc38nlnB+XX6nHLJzuUnKrs3u0GjVW8cXuE\nuhOnGlVOlNdl1H2B8zkjIABRzxgG03+L4kkHrQLnCmRuJAUyjnrbydLQJMRDq373\nchbJlmYi9OpA7p9gx9K2MAtczl9vvi8TIAD6oGstv9nNWNZrK4iNbC1+KQKBgA16\nVbXHFETDkqvLNituCsoeEHLHh4P7K99mOONdFYFDH8N6nAsQ5iyNyYg42B1w/xtP\n+RUsHh45DOnUq6C/CDmHlY+nuKGYWEyP73IreoRRZwK+eIpgIM/Sl4lgZil0M4e+\nNtNJDzRarQohlArHiatZpfZ44lUZVB9XacclEi6hAoGBAJMxEoYoBALpQpxm3dqb\nkewO1fPPAAKcH8SkYedaPnztlypfXXTFyVuRHMKFwy8E8fveZdfi49nmlZCGs0pH\nzg8KetB52yG38QD/S7S3/iIGuRJad7QQJ8nQNnR+Y9yXCiG6ZFr+WFvSZjwQ8Igi\nUSdlAJvLkrdJEteJDXt4cMvP\n-----END PRIVATE KEY-----\n",
      "client_email": "chattestme@msnchat-bd802.iam.gserviceaccount.com",
      "client_id": "111238606383783458001",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/chattestme%40msnchat-bd802.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    print("___________________________________ ");

    List<String> scopes = <String>[
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];
    try {
      http.Client client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);
      auth.AccessCredentials credentials =
          await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client,
      );
      print("______________________________________");
      print("Access Token: ${credentials.accessToken.data}");
      client.close();
      return credentials.accessToken.data;
    } catch (e) {
      print("Error obtaining access token: $e");
      return "";
    }
  }

  // Get device token for push notifications
  Future<String?> getDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
    return token;
  }

  // Update user push token in Firestore
  Future<void> updateUserToken(String userId) async {
    String? token = await getDeviceToken();
    if (token != null) {
      await _firestor.collection('users').doc(userId).update({
        'push_token': token,
      });
    }
  }

  ///change
  //
// Function to send a push notification using Firebase Cloud Messaging (FCM)
  Future<void> sendNotification(
      String token, String messageFromUser, String senderName) async {
    final String accessToken = await getAccessToken();
    if (accessToken.isEmpty) {
      print("Access token is empty, cannot send notification");
      return;
    }
    const String endpointFCM =
        'https://fcm.googleapis.com/v1/projects/msnchat-bd802/messages:send';

    final Map<String, dynamic> message = <String, dynamic>{
      "message": {
        "token": token,
        "notification": {"body": messageFromUser, "title": senderName}
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFCM),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print(
          'Failed to send notification: ${response.statusCode} - ${response.body}');
    }
    print("////////////////////////////////////////////////");
    print("Access Token: $accessToken");
    print("FCM Endpoint: $endpointFCM");
    print("Message Payload: ${jsonEncode(message)}");
  }

  // Function to create a new message and send a notification to the recipient
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

    await myroom.update({
      'last_message': message.msg,
      'last_message_time': message.createdAt,
    });

    DocumentSnapshot userDoc =
        await _firestor.collection('users').doc(message.toId).get();
    String? token = userDoc.get('push_token');
    String username = userDoc.get('name');

    if (token != null && token.isNotEmpty) {
      await sendNotification(token, message.msg, username);
    }
  }

  // Create new user with push token
  Future creatUser(UserProfile userprofil) async {
    try {
//change
      String? token = await getDeviceToken();
      userprofil.pushToken = token ?? '';

      await _firestor
          .collection('users')
          .doc(userprofil.id)
          .set(userprofil.toJson());
      print("User successfully created with pushToken");
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

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future imageSorge(File file, String roomid) async {
    String ext = file.path.split('.').last;
    // this is path
    final ref = firebaseStorage.ref().child('images/$roomid/'
        '${DateTime.now().microsecondsSinceEpoch}.$ext');

    await ref.putFile(file);

    return await ref.getDownloadURL();
  }
}
