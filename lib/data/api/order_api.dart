import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../api/api_config.dart';

class OrderApi {
  // get semua order
  static Future<Map<String, dynamic>> getOrders({int page = 1}) async {
    final box = GetStorage();
    final token = box.read('token');

    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/order?with_items=true&with_histories=true&page=$page',
      ),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      print('Response OrderAPI (page $page): $decoded');

      return {
        'data': decoded['data'] ?? [],
        'pagination': decoded['pagination'] ?? {},
      };
    } else {
      throw Exception(
        'Gagal ambil data order: ${response.statusCode} - ${response.body}',
      );
    }
  }

  // get detail order by id
  static Future<Map<String, dynamic>> getOrderDetail(int id) async {
    final box = GetStorage();
    final token = box.read('token');

    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/order/$id?with_items=true&with_histories=true',
      ),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['data'];
    } else {
      throw Exception(
        'Gagal ambil detail order: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
