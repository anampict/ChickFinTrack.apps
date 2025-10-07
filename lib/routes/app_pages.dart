import 'package:get/get.dart';
import 'package:my_app/navigation/MainNavigation.dart';
import 'package:my_app/routes/app_routes.dart';
import 'package:my_app/screens/admin/buatpesanan/BuatPesanan.dart';
import 'package:my_app/screens/admin/produk/DataProduk.dart';
import 'package:my_app/screens/admin/produk/TambahKategori.dart';
import 'package:my_app/screens/admin/produk/TambahKategoriProduk.dart';
import 'package:my_app/screens/admin/produk/TambahProduk.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.main, page: () => MainNavigation()),
    //tambahkategori
    GetPage(
      name: AppRoutes.KategoriProduk,
      page: () => const TambahkategoriProduk(),
    ),
    //dataproduk
    GetPage(name: AppRoutes.DataProduk, page: () => const Dataproduk()),
    //pesanan
    GetPage(name: AppRoutes.Pesanan, page: () => const Buatpesanan()),
    //tambahkategori
    GetPage(name: AppRoutes.TambahKategori, page: () => const Tambahkategori()),
    //tambahproduk
    GetPage(name: AppRoutes.TambahProduk, page: () => const TambahProduk()),
  ];
}
