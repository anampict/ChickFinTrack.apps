import 'package:my_app/data/api/product_api.dart';
import 'package:my_app/data/models/product_model.dart';

class ProductRepository {
  //get product
  Future<Map<String, dynamic>> fetchProducts({int page = 1}) async {
    final result = await ProductApi.getProducts(page: page);
    final products = (result['data'] as List)
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return {
      'products': products,
      'meta': result['meta'], // total, per_page, current_page, last_page
    };
  }

  //add product
  Future<ProductModel> addProduct(Map<String, dynamic> body) async {
    final data = await ProductApi.createProduct(body);
    return ProductModel.fromJson(data);
  }

  //edit product
  Future<ProductModel> updateProduct(int id, Map<String, dynamic> body) async {
    final data = await ProductApi.updateProduct(id, body);
    return ProductModel.fromJson(data);
  }

  // delete product
  Future<void> deleteProduct(int id) async {
    await ProductApi.deleteProduct(id);
  }
}
