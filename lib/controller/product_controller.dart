import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/data/models/product_model.dart';
import 'package:my_app/data/repositories/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository repository;
  ProductController({required this.repository});

  var products = <ProductModel>[].obs;
  var isLoading = false.obs;

  var selectedProduct = Rxn<ProductModel>();

  // Pagination
  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var isLoadMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    getProducts();
  }

  // GET product (page 1)
  Future<void> getProducts() async {
    try {
      isLoading.value = true;
      currentPage.value = 1;

      final response = await repository.fetchProducts(page: currentPage.value);
      final newProducts = response['products'] as List<ProductModel>;
      products.assignAll(newProducts);

      lastPage.value = response['meta']['last_page'] ?? 1;
    } catch (e) {
      print('Error getProducts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // LOAD MORE product (pagination)
  Future<void> loadMoreProducts() async {
    if (currentPage.value < lastPage.value && !isLoadMore.value) {
      try {
        isLoadMore.value = true;
        currentPage.value++;

        final response = await repository.fetchProducts(
          page: currentPage.value,
        );
        final newProducts = response['products'] as List<ProductModel>;
        products.addAll(newProducts);
      } catch (e) {
        print('Error loadMoreProducts: $e');
      } finally {
        isLoadMore.value = false;
      }
    }
  }

  //get product sesuai id
  Future<void> getProductById(int id) async {
    try {
      isLoading.value = true;
      final product = await repository.fetchProductById(id);
      selectedProduct.value = product;
    } catch (e) {
      print('Error getProductById: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ADD product
  Future<void> addProduct(Map<String, dynamic> body) async {
    try {
      isLoading.value = true;
      final newProduct = await repository.addProduct(body);
      products.insert(0, newProduct); // tampil di paling atas
    } catch (e) {
      print('Error addProduct: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // EDIT product
  Future<void> editProduct(int id, Map<String, dynamic> body) async {
    try {
      isLoading.value = true;
      final updatedProduct = await repository.updateProduct(id, body);
      final index = products.indexWhere((p) => p.id == id);
      if (index != -1) {
        products[index] = updatedProduct;
        products.refresh();
      }
    } catch (e) {
      print('Error editProduct: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // DELETE product
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
