import 'package:my_app/data/api/stock_api.dart';
import 'package:my_app/data/models/stock_model.dart';

class StockRepository {
  // ambil semua riwayat stok
  Future<List<StockModel>> getStock(int productId) async {
    final data = await StockApi.getStock(productId);
    return (data as List).map((e) => StockModel.fromJson(e)).toList();
  }

  // tambah stok
  Future<bool> addStock({
    required int productId,
    required int quantity,
    required String notes,
  }) async {
    final response = await StockApi.addStock(
      productId: productId,
      quantity: quantity,
      notes: notes,
    );
    return response.containsKey('message');
  }
}
