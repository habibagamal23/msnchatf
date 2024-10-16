import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msnchat/features/chat/message_cubit.dart';
import '../../features/chat/chatscreen.dart';
import '../../features/forget_pass/ui/ForgetScreen.dart';
import '../../features/home/model/user_info.dart';
import '../../features/home/ui/selectuser_screen.dart';
import '../../features/home/ui/home_screen.dart';
import '../../features/login/ui/login_screen.dart';
import '../../features/onboarding/ui/onboarding_screen.dart';
import '../../features/register/ui/signup_screen.dart';
import '../../features/splash/splash_screeen.dart';
import '../network_services/fireBase_data.dart';

class Routes {
  static const String splashScreen = '/splashscreen';
  static const String onBoardingScreen = '/onBoardingScreen';
  static const String loginScreen = '/loginScreen';
  static const String signUpScreen = '/signUpScreen';
  static const String homeScreen = '/homeScreen';
  static const String forgetpass = '/forgetpass';
  static const String selectUserScreen = '/SelectUserScreen';
  static const String chatScreen = '/chatscreen';
}

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case Routes.forgetpass:
        return MaterialPageRoute(
          builder: (_) => const ForgetPasswordScreen(),
        );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case Routes.signUpScreen:
        return MaterialPageRoute(
          builder: (_) => const SignupScreen(),
        );
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      case Routes.selectUserScreen:
        return MaterialPageRoute(
          builder: (_) => SelectUserScreen(),
        );
      case Routes.chatScreen:
        final userProfile = settings.arguments as UserProfile;
        return MaterialPageRoute(
          builder: (_) => ChatScreen(userProfile: userProfile),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
