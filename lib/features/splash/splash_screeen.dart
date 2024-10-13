import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/sharedprefrance/sharedprefrace.dart';
import '../../core/utils/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnAuth();
  }

  Future<void> _navigateBasedOnAuth() async {
    await Future.delayed(const Duration(seconds: 2));

    bool hasVisitedOnboarding = await SharedPrefsHelper.getVisitedOnboarding();
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && hasVisitedOnboarding) {
      Navigator.pushReplacementNamed(context, Routes.homeScreen);
    } else if (user == null && hasVisitedOnboarding) {
      Navigator.pushReplacementNamed(context, Routes.loginScreen);
    } else {
      Navigator.pushReplacementNamed(context, Routes.onBoardingScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(100),
          child: Image.asset( 'assets/chat.png',),
        ),
      ),
    );
  }
}
