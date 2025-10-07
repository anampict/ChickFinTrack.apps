import 'package:flutter/material.dart';
import 'package:my_app/controller/NavigationController.dart';
import 'package:my_app/screens/admin/HomeScreen.dart';
import 'package:my_app/screens/admin/profile/AdminProfile.dart';
import 'package:get/get.dart';

class MainNavigation extends StatelessWidget {
  MainNavigation({super.key});

  final NavigationController navController = Get.put(NavigationController());

  final List<Widget> _pages = const [Homescreen(), AdminProfile()];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _pages[navController.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navController.selectedIndex.value,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.orange,
          onTap: (index) {
            navController.changePage(index);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
