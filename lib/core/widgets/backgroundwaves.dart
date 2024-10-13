import 'package:flutter/material.dart';


class CustomBackground extends StatelessWidget {
  const CustomBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/bgwaves.png',
          fit: BoxFit.cover,
          width: double.infinity,
        ),

        Positioned(
          top: 70,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/chat.png',
            fit: BoxFit.contain,
            width: 200,
            height: 100,
            // Adjust height as needed
          ),
        ),

        Positioned(
          bottom: 70,
          left: 0,
          right: 0,
          child: Text(
            'Welcome',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
          ),
        ),
      ],
    );
  }
}
