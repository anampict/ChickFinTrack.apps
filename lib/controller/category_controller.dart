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
}
