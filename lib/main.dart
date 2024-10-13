import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network_services/fireBase_data.dart';
import 'core/utils/routes.dart';
import 'features/home/logic/logic_users/users_cubit.dart';
import 'features/home/logic/rooms_cubit/rooms_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<RoomsCubit>(
            create: (context) => RoomsCubit(FireBaseData()),
          ),
          BlocProvider<UsersCubit>(
            create: (context) => UsersCubit(FireBaseData()),
          ),
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
        ));
  }
}
