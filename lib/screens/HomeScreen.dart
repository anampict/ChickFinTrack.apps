import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 6.0),
              child: SvgPicture.asset(
                "assets/icons/home.svg",
                width: 24,
                height: 24,
              ),
            ),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 6.0),
              child: SvgPicture.asset(
                "assets/icons/profile.svg",
                width: 24,
                height: 24,
              ),
            ),
            label: "Profile",
          ),
        ],
        backgroundColor: Color(0xffEE9400),
      ),
      body: SingleChildScrollView(
        child: 
        Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0)),
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 20.0)),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xffEE9400),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Image.asset(
                    "assets/images/image.png",
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 7.0)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Back",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    "User",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      )
      
       
    );
  }
}
