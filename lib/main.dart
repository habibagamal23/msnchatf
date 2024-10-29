import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msnchat/features/chat/loggic/messages_cubit.dart';
import 'package:msnchat/features/home/logic_user/logic_rooms/rooms_cubit.dart';
import 'package:msnchat/features/home/logic_user/users_cubit.dart';
import 'core/network_services/fireBase_data.dart';
import 'core/network_services/notifcations.dart';
import 'core/utils/routes.dart';
import 'firebase_options.dart';

// this should to be here
// Handle notifications when the app is closed and receives a message in the background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Nofifcation().requestNotificationPermissions();
  runApp(const MyApp());
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
