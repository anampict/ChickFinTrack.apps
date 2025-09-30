import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffEE9400),
      child: Center(
        child: Image.asset("assets/images/logoapk.png"),
      ),

    );
  }
}