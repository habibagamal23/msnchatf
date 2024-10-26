import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msnchat/features/chat/loggic/messages_cubit.dart';
import 'package:msnchat/features/home/logic_user/logic_rooms/rooms_cubit.dart';
import 'package:msnchat/features/home/logic_user/users_cubit.dart';
import 'core/network_services/fireBase_data.dart';
import 'core/utils/routes.dart';
import 'firebase_options.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Ask for permission to show notifications (for iOS)
  await _requestNotificationPermissions();
  runApp(const MyApp());
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

Future<void> _requestNotificationPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UsersCubit>(
            create: (context) => UsersCubit(FireBaseData())),
        BlocProvider<RoomsCubit>(
            create: (context) => RoomsCubit(FireBaseData())),
        BlocProvider<MessagesCubit>(
            create: (context) => MessagesCubit(FireBaseData())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: Routes.splashScreen,
      ),
    );
  }
}
