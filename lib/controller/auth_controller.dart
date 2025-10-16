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
  var token = ''.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 200), () {
      final savedToken = box.read('token');
      if (savedToken != null) {
        token.value = savedToken;
        isLoggedIn.value = true;

        if (!Get.isRegistered<CategoryController>()) {
          Get.put(CategoryController(), permanent: true);
        }
        Get.find<CategoryController>().fetchCategories();

        if (!Get.isRegistered<ProductController>()) {
          Get.put(
            ProductController(repository: ProductRepository()),
            permanent: true,
          );
        }
        Get.find<ProductController>().getProducts();
      }
    });
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    final result = await _authRepository.login(email, password);
    isLoading.value = false;

    if (result != null && result['token'] != null) {
      token.value = result['token'];
      box.write('token', token.value);
      box.write('user', result['user']);

      isLoggedIn.value = true;

      if (!Get.isRegistered<CategoryController>()) {
        Get.put(CategoryController(), permanent: true);
      }
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

  void logout() {
    box.remove('token');
    box.remove('user');
    token.value = '';
    isLoggedIn.value = false;

    if (Get.isRegistered<CategoryController>()) {
      Get.delete<CategoryController>(force: true);
    }
    if (Get.isRegistered<ProductController>()) {
      Get.delete<ProductController>(force: true);
    }

    Get.offAllNamed(AppRoutes.loginScreen);
    Get.snackbar(
      'Logout Berhasil',
      'Anda telah keluar dari aplikasi',
      snackPosition: SnackPosition.TOP,
    );
  }
}
