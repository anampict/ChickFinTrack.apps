import 'package:flutter/material.dart';
import 'package:my_app/component/Menu2.dart';
import 'package:my_app/controller/category_controller.dart';
import 'package:my_app/navigation/MainNavigation.dart';
import 'package:my_app/routes/app_pages.dart';
import 'package:my_app/routes/app_routes.dart';
import 'package:my_app/screens/admin/HomeScreen.dart';
import 'package:my_app/screens/SplashScreen.dart';
import 'package:my_app/screens/admin/buatpesanan/BuatPesanan.dart';
import 'package:my_app/screens/admin/produk/DataProduk.dart';
import 'package:my_app/screens/admin/produk/TambahKategori.dart';
import 'package:my_app/screens/admin/produk/DaftarKategoriProduk.dart';
import 'package:my_app/screens/admin/produk/TambahProduk.dart';
import 'package:my_app/screens/admin/profile/AdminProfile.dart';
import 'package:get/get.dart';

void main() {
  Get.put(CategoryController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: AppRoutes.main,
      getPages: AppPages.pages,
    );
  }
}
