import 'package:my_app/data/api/product_api.dart';
import 'package:my_app/data/models/product_model.dart';

class ProductRepository {
  Future<List<ProductModel>> fetchProducts() async {
    final data = await ProductApi.getProducts(); // <- ini List<dynamic>
    return data
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
