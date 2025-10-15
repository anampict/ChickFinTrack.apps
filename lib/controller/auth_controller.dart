import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_app/controller/category_controller.dart';
import 'package:my_app/controller/product_controller.dart';
import 'package:my_app/data/repositories/product_repository.dart';
import '../data/repositories/auth_repository.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final box = GetStorage();

  var isLoading = false.obs;
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Cek token saat app start
    final token = box.read('token');
    if (token != null) {
      isLoggedIn.value = true;
      // Bisa fetch data awal
      if (!Get.isRegistered<CategoryController>()) {
        Get.put(CategoryController(), permanent: true);
      }
      print(Get.isRegistered<CategoryController>());
      Get.find<CategoryController>().fetchCategories();

      if (!Get.isRegistered<ProductController>()) {
        Get.put(
          ProductController(repository: ProductRepository()),
          permanent: true,
        );
      }
      Get.find<ProductController>().getProducts();
    }
  }

  //login
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    final result = await _authRepository.login(email, password);
    isLoading.value = false;

    if (result != null && result['token'] != null) {
      final token = result['token'];
      final user = result['user'];

      // Simpan token dan user ke GetStorage
      box.write('token', token);
      print(box.read('token'));
      box.write('user', user);

      isLoggedIn.value = true;
      await Get.find<CategoryController>().fetchCategories();
      if (!Get.isRegistered<ProductController>()) {
        Get.put(
          ProductController(repository: ProductRepository()),
          permanent: true,
        );
      }
      await Get.find<ProductController>().getProducts();
      Get.snackbar('Sukses', 'Login berhasil');
      Get.offAllNamed(AppRoutes.main);
    } else {
      Get.snackbar('Gagal', result?['message'] ?? 'Login gagal');
    }
  }

  //logout
  void logout() {
    box.remove('token');
    box.remove('user');

    isLoggedIn.value = false;

    Get.offAllNamed(AppRoutes.loginScreen);

    Get.snackbar(
      'Logout Berhasil',
      'Anda telah keluar dari aplikasi',
      snackPosition: SnackPosition.TOP,
    );
  }
}
