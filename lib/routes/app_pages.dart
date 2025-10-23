import 'package:get/get.dart';
import 'package:my_app/controller/users_controller.dart';
import 'package:my_app/data/models/product_model.dart';
import 'package:my_app/navigation/MainNavigation.dart';
import 'package:my_app/routes/app_routes.dart';
import 'package:my_app/screens/SplashScreen.dart';
import 'package:my_app/screens/admin/buatpesanan/BuatPesanan.dart';
import 'package:my_app/screens/admin/buatpesanan/DaftarPesanan.dart';
import 'package:my_app/screens/admin/manajemenpengguna/DaftarPengguna.dart';
import 'package:my_app/screens/admin/manajemenpengguna/TambahPengguna.dart';
import 'package:my_app/screens/admin/produk/DataProduk.dart';
import 'package:my_app/screens/admin/produk/DetailProduk.dart';
import 'package:my_app/screens/admin/produk/TambahKategori.dart';
import 'package:my_app/screens/admin/produk/DaftarKategoriProduk.dart';
import 'package:my_app/screens/admin/produk/TambahProduk.dart';
import 'package:my_app/screens/auth/LoginScreen.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.SplashScreen, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.loginScreen, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.main, page: () => MainNavigation()),
    //tambahkategori
    GetPage(
      name: AppRoutes.KategoriProduk,
      page: () => const Daftarkategoriproduk(),
    ),
    //dataproduk
    GetPage(name: AppRoutes.DataProduk, page: () => const Dataproduk()),
    //pesanan
    GetPage(name: AppRoutes.DaftarPesanan, page: () => const Daftarpesanan()),
    GetPage(name: AppRoutes.Pesanan, page: () => const Buatpesanan()),
    //tambahkategori
    GetPage(name: AppRoutes.TambahKategori, page: () => const Tambahkategori()),
    //tambahproduk
    GetPage(name: AppRoutes.TambahProduk, page: () => const TambahProduk()),
    //detailproduk
    GetPage(name: AppRoutes.DetailProduk, page: () => const DetailProduk()),
    //daftarpengguna
    GetPage(name: AppRoutes.DaftarPengguna, page: () => const DaftarPengguna()),
    //tambahpengguna
    GetPage(
      name: AppRoutes.TambahPengguna,
      page: () => const Tambahpengguna(),
      binding: BindingsBuilder(() {
        Get.lazyPut<UserController>(() => UserController());
      }),
    ),
  ];
}
