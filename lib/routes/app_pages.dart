import 'package:get/get.dart';
import 'package:my_app/navigation/MainNavigation.dart';
import 'package:my_app/routes/app_routes.dart';
import 'package:my_app/screens/admin/produk/TambahKategoriProduk.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.main, page: () => MainNavigation()),
    GetPage(
      name: AppRoutes.KategoriProduk,
      page: () => const TambahkategoriProduk(),
    ),
  ];
}
