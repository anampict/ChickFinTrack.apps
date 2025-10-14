import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_app/routes/app_routes.dart';
import 'package:my_app/screens/admin/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    final token = box.read('token');
    if (token != null && token.isNotEmpty) {
      // Kalau token ada → langsung ke halaman utama
      Get.offAllNamed(AppRoutes.main);
    } else {
      // Kalau tidak ada token → ke halaman login
      Get.offAllNamed(AppRoutes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEE9400),
      body: Center(child: Image.asset("assets/images/logoapk.png")),
    );
  }
}
