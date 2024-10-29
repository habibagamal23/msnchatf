import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
import 'package:msnchat/core/network_services/fireBase_data.dart';

class Nofifcation {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Nofifcation() {
    // 1. In the constructor, listen for any token changes and update the user if it changes
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      if (firebaseAuth.currentUser != null) {
        print("Token refreshed: $newToken");
        await FireBaseData().updateUserToken(firebaseAuth.currentUser!.uid);
      }
    });
  }



  // 3. Request permission to send notifications to this device
  Future<void> requestNotificationPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // 4. Get a unique push token for each device, which will be sent to the user
  Future getDevicesToken() async {
    String? token = await messaging.getToken();
    print("create token for ech dvices $token");
    return token;
  }

  // 5. Obtain an access token for Google Cloud services to use for authentication
  Future<String> getAccesTokenSevcesAccount() async {
    final Map<String, String> serviceAcconJson = {
      /// add your file
      // "type": "service_account",
      // "project_id": "msnchat-bd802",
      // "private_key_id": "194a99a184beceec1117c5669ed8e71e996b8887",
      // "private_key":
      //     "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDdIFlkxoou4gcu\nAxS7nQ8BZ72kwoKfxRzgHamrMPy3stFz0+5V8AhjsfZSyvz2zPRxt4nfipB6qf73\nIAA8u5LoYVmCVj2YTwoo5WTDQ9wCuxrZ2iMnQBLM12grRaOWRzFpK17hQLff4wN5\nqz1Hzl38WnEnRax8lwes6GttyzduE9h2IPR6SLrg2OBWlhCGIo0prWNKFQMrUkwG\n5yXzKJUHRDx3VCjH/PhqKFDEjGtt+WF/cMJnM0yldetXS2XKz5VgB/X5KOLe6nLt\nMd+wIoN+UVEj2oGKXOvBw2s2c3MTuR4TAJ5i2z1u2gLbST1AiY3roJLKKRlzx9YL\nQbQCrHdDAgMBAAECggEAQj1eigGvgzvSSsZBf7IcvJ8HAEQEPTge3kQEf3O9QIog\nlEH4M2YkHTlCQKrt/ECJOUdx1bT8csJZzk2XxJmr+FCxL4oGCYoj0PxmotfBIFBM\nStY9kZRwDUy5t7y0tF+/PXHwiimI61hlwhy5zrjTDrVJECqe8PONKQ62n70wbZiV\nvuSGZZI5Gg348tQ38JtNC8MRtRKmFg1rOugUCIya8KZ9o0M3kKnnoTrv9DN4YwJ2\n3t+IKABYyZ1L9F9ZP6C8woYEXYeOv2wfmyUdVWUUWpCmq0Zpm9CHQJx8EwJ/gewC\nkpDFhCxiD2JXeQHrKiuxxlNzI6q23DQ1UjyNb8Z2AQKBgQDxwMZliFsIXlbJQkN5\nA6hDlGmHG4NTlXuuJJa+/+KGo7IZxKs6LhRTgumjQKq+u6Vkx9OTzZmW/QFA6112\nIVtc52MInG0uTRDbuAeDJ2k/Ln3v0F7p70oPncRuIRDim64ocVy5BTinwO5q3N3m\nm5ZANQsPhZr3XLJn6WHooy7kkQKBgQDqKGN1/D+ARr7D0m3943PZqRWTQsARHWhw\nSsyOX/dak/TYFitmGckIEft7CSg9Muq0TVVRjZjdYNAvgvDjXZZ8BxvC9lg7rT+g\ntdWLIdVOVMSM/Bnir84tfrSMN2lqpcsOr8i4PDpkfutLsU8eJ3gNAkB5KQr4exYJ\nRpH58oe4kwKBgQCl3QFBgAAVCcS5aIEqcdvsIdMVI0dC/XhRzkCu4pjkj0MOcuSX\nki3X7iWmICQFoHClaIQ9D/6knQlTJSiGd/RbFVXY/pnZ/n3mgaiFz3BiLN+yvV+h\nWM+TT0cJ2B3hm7YtgTmAp5hrX+8z2j1UjsLTYpEoIR5lQHAW4wSNvAfcQQKBgQCO\nOvovMIlh4Zb+W1N0ZDR6gboZOPJxcut9SfH2iVQ2MKkImG7EFeWGgWW/1lAa3FK0\nMkUgxGGWFrheI6sucCp4K9kxE3GEzjdX5xtO574pVlQNTxRqHV+fQtdoVEA0B4DP\n6vaA8hSF9pH16D2mk1LYlAWVktiXFizMdZE1wZuvAQKBgDy1rqge8mBG5jrJV/rD\nmpfGi6X8IETz2zK4ibSxzufksHwKH6wH8RDeidQHHhflArsazvAjlBIyMXtM8T2t\n3unDDzXGlo/tLCLDhR6CZHz9LiMUlWRAfx8hN4IImDGKfX4fa3mnpx75+VehaFn7\n1KRO0xSx74F21WxjsFW59gwf\n-----END PRIVATE KEY-----\n",
      // "client_email": "chatnoti@msnchat-bd802.iam.gserviceaccount.com",
      // "client_id": "101802749039949035925",
      // "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      // "token_uri": "https://oauth2.googleapis.com/token",
      // "auth_provider_x509_cert_url":
      //     "https://www.googleapis.com/oauth2/v1/certs",
      // "client_x509_cert_url":
      //     "https://www.googleapis.com/robot/v1/metadata/x509/chatnoti%40msnchat-bd802.iam.gserviceaccount.com",
      // "universe_domain": "googleapis.com"
    };

    print("----------------------- Service json");

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    try {
      http.Client client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAcconJson), scopes);

      auth.AccessCredentials credential =
          await auth.obtainAccessCredentialsViaServiceAccount(
              auth.ServiceAccountCredentials.fromJson(serviceAcconJson),
              scopes,
              client);
      client.close();

      return credential.accessToken.data;
    } catch (e) {
      return "error is $e";
    }
  }

  // 6. Send a notification using the API with the HTTP package
  Future senNotifaction(String body, String sendrname, String token) async {
    final String accestoken = await getAccesTokenSevcesAccount();

    const String endpoint =
        'https://fcm.googleapis.com/v1/projects/msnchat-bd802/messages:send';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accestoken',
    };

    final Map<String, dynamic> messge = {
      "message": {
        "token": token,
        "notification": {"body": body, "title": sendrname}
      }
    };

    try {
      if (accestoken.isEmpty) {
        print("is empty acces token ");
        return "";
      }

      http.Response response = await http.post(Uri.parse(endpoint),
          headers: headers, body: jsonEncode(messge));
      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print(
            'Failed to send notification: ${response.statusCode} - ${response.body}');
      }
      print("////////////////////////////////////////////////");
      print("Access Token: $accestoken");
      print("FCM Endpoint: $endpoint");
      print("Message Payload: ${jsonEncode(messge)}");
    } catch (e) {
      print("erorr when send api $e ");
    }
  }
}
