import 'package:my_app/data/api/product_api.dart';
import 'package:my_app/data/models/product_model.dart';

class ProductRepository {
  //get product
  Future<List<ProductModel>> fetchProducts() async {
    final data = await ProductApi.getProducts(); // <- ini List<dynamic>
    return data
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
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
}
