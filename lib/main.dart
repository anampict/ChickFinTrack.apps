import 'package:flutter/material.dart';
import 'package:my_app/component/Menu2.dart';
import 'package:my_app/screens/admin/HomeScreen.dart';
import 'package:my_app/screens/SplashScreen.dart';
import 'package:my_app/screens/admin/produk/DataProduk.dart';
import 'package:my_app/screens/admin/produk/TambahKategori.dart';
import 'package:my_app/screens/admin/produk/TambahKategoriProduk.dart';
import 'package:my_app/screens/admin/produk/TambahProduk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: TambahProduk(),
    );
  }
}
