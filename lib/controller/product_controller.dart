import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/data/models/product_model.dart';
import 'package:my_app/data/repositories/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository repository;
  ProductController({required this.repository});

  var products = <ProductModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getProducts();
  }

  //get product
  Future<void> getProducts() async {
    try {
      isLoading.value = true;
      final data = await repository.fetchProducts();
      products.assignAll(data);
    } catch (e) {
      print('Error getProducts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  //add product
  Future<void> addProduct(Map<String, dynamic> body) async {
    try {
      isLoading.value = true;

      final newProduct = await repository.addProduct(body);
      products.add(newProduct);
    } catch (e) {
      print('Error addProduct: $e');
    } finally {
      isLoading.value = false;
    }
  }

  //edit product
  Future<void> editProduct(int id, Map<String, dynamic> body) async {
    try {
      isLoading.value = true;
      final updatedProduct = await repository.updateProduct(id, body);

      // cari index produk yang diedit dan update di list observable
      final index = products.indexWhere((p) => p.id == id);
      if (index != -1) {
        products[index] = updatedProduct;
        products.refresh(); // trigger UI update
      }
    } catch (e) {
      print('Error editProduct: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      isLoading.value = true;
      await repository.deleteProduct(id);

      products.removeWhere((p) => p.id == id);
      products.refresh();

      Get.snackbar(
        'Sukses',
        'Produk berhasil dihapus',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
    } catch (e) {
      print('Error deleteProduct: $e');
      if (e.toString().contains('422') ||
          e.toString().contains('Cannot delete product')) {
        Get.snackbar(
          'Tidak Bisa Dihapus',
          'Produk ini masih terhubung dengan pesanan dan tidak dapat dihapus.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange.withOpacity(0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 8,
        );
      } else {
        Get.snackbar(
          'Gagal',
          'Terjadi kesalahan saat menghapus produk',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 8,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
