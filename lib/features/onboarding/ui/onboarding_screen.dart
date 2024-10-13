import 'package:flutter/material.dart';

import '../../../core/sharedprefrance/sharedprefrace.dart';
import '../../../core/utils/routes.dart';
import '../../../core/widgets/backgroundwaves.dart';
import '../../../core/widgets/button_app.dart';


class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CustomBackground(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Stay connected with the latest news and chat with your mates in real-time. Let\'s get started by creating an account or logging in.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20,),
                Text(
                  'ChatMate . Let\'s get started by creating an account or logging in.',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppTextButton(
                buttonText: "Get Started",
                textStyle: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: Colors.white),
                onPressed: () async {
                  await SharedPrefsHelper.setVisitedOnboarding(true);
                  Navigator.pushReplacementNamed(context, Routes.loginScreen);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
