import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/data/models/users_model.dart';
import 'package:my_app/data/repositories/users_repository.dart';

class UserController extends GetxController {
  final UserRepository _repository = UserRepository();

  var users = <UserModel>[].obs;
  var filteredUsers = <UserModel>[].obs;

  var isLoading = false.obs;
  var isLoadMore = false.obs;

  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var selectedRole = 'Semua'.obs;
  var isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUsers();
  }

  // 🔹 Ambil data awal
  Future<void> getUsers() async {
    try {
      isLoading.value = true;
      currentPage.value = 1;

      final result = await _repository.getUsers(page: currentPage.value);
      final fetchedUsers = result['users'] as List<UserModel>;
      users.assignAll(fetchedUsers);
      lastPage.value = result['last_page'];

      _applyFilter();
    } catch (e) {
      print('Error fetch users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Pagination (load more)
  Future<void> loadMoreUsers() async {
    if (isLoadMore.value || currentPage.value >= lastPage.value) return;

    try {
      isLoadMore.value = true;
      currentPage.value++;

      final result = await _repository.getUsers(page: currentPage.value);
      final fetchedUsers = result['users'] as List<UserModel>;

      users.addAll(fetchedUsers);
      _applyFilter();
    } catch (e) {
      print('Error load more users: $e');
    } finally {
      isLoadMore.value = false;
    }
  }

  // 🔹 Filter role
  void filterByRole(String role) {
    selectedRole.value = role;
    _applyFilter();
  }

  // Terapkan filter berdasarkan role terpilih
  void _applyFilter() {
    if (selectedRole.value == 'Semua') {
      filteredUsers.assignAll(users);
    } else {
      filteredUsers.assignAll(
        users.where((u) => _roleLabel(u.role) == selectedRole.value).toList(),
      );
    }
  }

  // Mapping role dari API ke label UI
  String _roleLabel(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Admin';
      case 'courier':
        return 'Kurir';
      case 'customer':
        return 'Pelanggan';
      default:
        return role;
    }
  }

  // Tambah user
  Future<void> createUser(Map<String, dynamic> body) async {
    try {
      isSubmitting.value = true;
      final newUser = await _repository.createUser(body);

      users.insert(0, newUser);
      _applyFilter();

      Get.back(); // tutup form
      Get.snackbar(
        'Sukses',
        'User berhasil ditambahkan',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
