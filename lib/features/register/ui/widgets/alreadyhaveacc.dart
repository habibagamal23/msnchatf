import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/routes.dart';
import '../../../../core/utils/styles.dart';

class AlreadyHaveAccountText extends StatelessWidget {
  const AlreadyHaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Already have an account?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextSpan(
              text: ' Login',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: ColorsManager.mainBlue,
                    fontWeight: FontWeight.bold,
                  ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushReplacementNamed(context, Routes.loginScreen);
                },
            ),
          ],
        ),
      ),
    );
  }
}
