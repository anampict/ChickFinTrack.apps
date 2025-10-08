import 'package:my_app/data/api/category_api.dart';
import 'package:my_app/data/models/category_model.dart';

class CategoryRepository {
  Future<List<CategoryModel>> getAllCategories() async {
    final data = await CategoryApi.getCategories();
    print(" Data kategori dari API: $data");
    return (data as List).map((e) => CategoryModel.fromJson(e)).toList();
  }
}
