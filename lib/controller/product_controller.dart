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
}
