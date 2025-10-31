import 'package:flutter/material.dart';
import 'dart:convert';
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

  var userDetail = Rxn<UserModel>(); // Rxn artinya bisa null
  var isDetailLoading = false.obs;

  var isSubmittingAddress = false.obs;

  var cities = <dynamic>[].obs;
  var districts = <dynamic>[].obs;

  var isLoadingCities = false.obs;
  var isLoadingDistricts = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUsers();
  }

  // Ambil data awal
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

      // Coba parsing error dari backend (mis. {"message":"..."}) dan tampilkan snackbar
      final raw = e.toString();
      String messageToShow = 'Gagal memuat daftar pengguna';

      try {
        final firstBrace = raw.indexOf('{');
        if (firstBrace != -1) {
          final jsonPart = raw.substring(firstBrace);
          final parsed = jsonDecode(jsonPart);
          if (parsed is Map && parsed['message'] != null) {
            final backendMsg = parsed['message'].toString();
            if (backendMsg.toLowerCase().contains('unauth')) {
              messageToShow =
                  'Sesi login Anda telah habis, silakan login ulang.';
            } else {
              messageToShow = backendMsg;
            }
          } else {
            if (raw.toLowerCase().contains('unauth')) {
              messageToShow =
                  'Sesi login Anda telah habis, silakan login ulang.';
            } else {
              messageToShow = raw;
            }
          }
        } else {
          if (raw.toLowerCase().contains('unauth')) {
            messageToShow = 'Sesi login Anda telah habis, silakan login ulang.';
          } else {
            messageToShow = raw;
          }
        }
      } catch (_) {
        if (raw.toLowerCase().contains('unauth')) {
          messageToShow = 'Sesi login Anda telah habis, silakan login ulang.';
        } else {
          messageToShow = raw;
        }
      }

      Get.snackbar(
        'Error',
        messageToShow,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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

  Future<void> getUserDetail(int id) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        isDetailLoading.value = true;

        final result = await _repository.getUserById(id);
        userDetail.value = result;
      } catch (e) {
        print('Error fetch user detail: $e');
        Get.snackbar(
          'Error',
          'Gagal memuat detail pengguna',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isDetailLoading.value = false;
      }
    });
  }

  // Update user
  Future<void> updateUser(int id, Map<String, dynamic> body) async {
    try {
      isSubmitting.value = true;

      final updatedUser = await _repository.updateUser(id, body);

      // update list user di memori agar tampilan langsung berubah
      final index = users.indexWhere((u) => u.id == id);
      if (index != -1) {
        users[index] = updatedUser;
        _applyFilter();
      }

      Get.back(); // tutup form
      Get.snackbar(
        'Sukses',
        'User berhasil diperbarui',
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

  //tambah alamat
  Future<void> createAddress({
    required int userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      isSubmittingAddress.value = true;
      final result = await _repository.createAddress(
        userId: userId,
        data: data,
      );

      // Tambahkan alamat ke userDetail bila sudah ada
      if (userDetail.value != null) {
        userDetail.value!.addresses.add(AddressModel.fromJson(result));
        userDetail.refresh(); // refresh agar UI update
        // Tampilkan snackbar sukses
        Get.snackbar(
          'Sukses',
          'Alamat berhasil ditambahkan',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("❌ Gagal menambah alamat: $e");
      Get.snackbar("Error", "Gagal menambah alamat");
    } finally {
      isSubmittingAddress.value = false;
    }
  }

  // UPDATE alamat
  Future<void> updateAddress({
    required int userId,
    required int addressId,
    required Map<String, dynamic> data,
  }) async {
    try {
      isSubmittingAddress.value = true;

      final result = await _repository.updateAddress(
        userId: userId,
        addressId: addressId,
        data: data,
      );

      // Kalau userDetail ada, update list local
      if (userDetail.value != null) {
        final index = userDetail.value!.addresses.indexWhere(
          (a) => a.id == addressId,
        );

        if (index != -1) {
          userDetail.value!.addresses[index] = AddressModel.fromJson(result);
        }

        userDetail.refresh(); // agar UI update
      }

      Get.back();
      Get.snackbar(
        "Sukses",
        "Alamat berhasil diperbarui",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print("Gagal update alamat: $e");
      Get.snackbar(
        "Error",
        "Gagal memperbarui alamat",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmittingAddress.value = false;
    }
  }

  //fetch alamat
  Future<void> fetchCities() async {
    try {
      isLoadingCities.value = true;
      final result = await _repository.fetchCities();
      cities.assignAll(result);
    } catch (e) {
      print("❌ Gagal fetch cities: $e");
      Get.snackbar("Error", "Gagal memuat daftar kota");
    } finally {
      isLoadingCities.value = false;
    }
  }

  Future<void> fetchDistricts(int cityId) async {
    try {
      isLoadingDistricts.value = true;
      final result = await _repository.fetchDistricts(cityId);
      districts.assignAll(result);
    } catch (e) {
      print("❌ Gagal fetch districts: $e");
      Get.snackbar("Error", "Gagal memuat daftar kecamatan");
    } finally {
      isLoadingDistricts.value = false;
    }
  }

  // Hapus alamat
  Future<void> deleteAddress({
    required int userId,
    required int addressId,
  }) async {
    try {
      await _repository.deleteAddress(userId: userId, addressId: addressId);

      // Hapus alamat dari list di memori
      if (userDetail.value != null) {
        userDetail.value!.addresses.removeWhere((a) => a.id == addressId);
        userDetail.refresh(); // refresh UI
      }

      Get.snackbar(
        "Sukses",
        "Alamat berhasil dihapus",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print("❌ Gagal menghapus alamat: $e");
      Get.snackbar(
        "Error",
        "Gagal menghapus alamat",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
