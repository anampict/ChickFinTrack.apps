import 'package:get/get.dart';
import 'package:my_app/data/models/category_model.dart';
import 'package:my_app/data/repositories/category_repository.dart';

class CategoryController extends GetxController {
  final CategoryRepository _repository = CategoryRepository();

  var categories = <CategoryModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  //fetch semua kategori
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      categories.value = await _repository.getAllCategories();
    } catch (e) {
      print('Error fetch categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  //add kategori
  Future<void> addCategory(String name, String description) async {
    try {
      isLoading.value = true;
      final newCategory = await _repository.addCategory(name, description);
      categories.add(newCategory);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // update kategori
  Future<void> updateCategory(int id, String name, String description) async {
    try {
      isLoading.value = true;
      final updatedCategory = await _repository.updateCategory(
        id,
        name,
        description,
      );

      // Update item di list lokal
      final index = categories.indexWhere((c) => c.id == id);
      if (index != -1) {
        categories[index] = updatedCategory;
        categories.refresh(); // penting agar UI auto rebuild
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // delete kategori
  Future<void> deleteCategory(int id) async {
    try {
      // isLoading.value = true;
      await _repository.deleteCategory(id);

      // Hapus dari list lokal
      categories.removeWhere((c) => c.id == id);
    } catch (e) {
      rethrow; // biar error bisa ditangani di UI
    } finally {
      isLoading.value = false;
    }
  }
}
