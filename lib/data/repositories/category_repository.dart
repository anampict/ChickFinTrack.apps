import 'package:my_app/data/api/category_api.dart';
import 'package:my_app/data/models/category_model.dart';

class CategoryRepository {
  //get semua kategori
  Future<List<CategoryModel>> getAllCategories() async {
    final data = await CategoryApi.getCategories();
    print(" Data kategori dari API: $data");
    return (data as List).map((e) => CategoryModel.fromJson(e)).toList();
  }

  //tambah kategori
  Future<CategoryModel> addCategory(String name, String description) async {
    final response = await CategoryApi.addCategory(
      name: name,
      description: description,
    );
    final data = response['data'];
    return CategoryModel.fromJson({...data, 'products_count': 0});
  }

  // edit kategori
  Future<CategoryModel> updateCategory(
    int id,
    String name,
    String description,
  ) async {
    final response = await CategoryApi.updateCategory(
      id: id,
      name: name,
      description: description,
    );

    final data = response['data'];
    return CategoryModel.fromJson({...data, 'products_count': 0});
  }

  // hapus kategori
  Future<void> deleteCategory(int id) async {
    await CategoryApi.deleteCategory(id);
  }
}
