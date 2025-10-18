import 'package:get/get.dart';
import 'package:my_app/data/models/stock_model.dart';
import 'package:my_app/data/repositories/stock_repository.dart';

class StockController extends GetxController {
  final StockRepository _repository = StockRepository();

  var stockList = <StockModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchStock(int productId) async {
    try {
      isLoading.value = true;
      stockList.value = await _repository.getStock(productId);
    } catch (e) {
      print('Error fetch stock: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addStock(int productId, int qty, String notes) async {
    try {
      final success = await _repository.addStock(
        productId: productId,
        quantity: qty,
        notes: notes,
      );
      if (success) {
        await fetchStock(productId); // refresh list setelah tambah stok
      }
      return success;
    } catch (e) {
      print('Error add stock: $e');
      return false;
    }
  }
}
