import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class StockApi {
  //get stok
  static Future<List<dynamic>> getStock(int productId) async {
    final box = GetStorage();
    final token = box.read('token');
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/products/$productId/stock'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body['data'];
    } else {
      throw Exception('Gagal mengambil data stok');
    }
  }

  // tambah stok
  static Future<Map<String, dynamic>> addStock({
    required int productId,
    required int quantity,
    required String notes,
  }) async {
    final box = GetStorage();
    final token = box.read('token');
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/products/$productId/stock'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode({'quantity': quantity, 'notes': notes}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal menambahkan stok');
    }
  }
}
