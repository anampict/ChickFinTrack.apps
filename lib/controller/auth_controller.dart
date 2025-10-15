import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_app/controller/category_controller.dart';
import '../data/repositories/auth_repository.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final box = GetStorage();

  var isLoading = false.obs;
  var isLoggedIn = false.obs;

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
      box.write('user', user);

      isLoggedIn.value = true;
      await Get.find<CategoryController>().fetchCategories();
      Get.snackbar('Sukses', 'Login berhasil');
      Get.offAllNamed(AppRoutes.main);
    } else {
      Get.snackbar('Gagal', result?['message'] ?? 'Login gagal');
    }
  }

  //logout
  void logout() {
    final box = GetStorage();
    box.remove('token');

    isLoggedIn.value = false;

    if (Get.isRegistered<AuthController>()) {
      Get.delete<AuthController>(force: true);
    }
    Get.offAllNamed(AppRoutes.loginScreen);

    Get.snackbar(
      'Logout Berhasil',
      'Anda telah keluar dari aplikasi',
      snackPosition: SnackPosition.TOP,
    );
  }
}
