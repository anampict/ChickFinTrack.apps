import 'package:flutter/material.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: Center(
       child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Welcome to Home Screen"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("ini row 1"),
              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
              Text("ini row 2")
            ],

          )
        ],
       ),

      ),
    );
  }
}