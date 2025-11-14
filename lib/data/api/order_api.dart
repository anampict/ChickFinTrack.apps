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

  //tambaha pesanan
  static Future<Map<String, dynamic>> createOrder(
    Map<String, dynamic> body,
  ) async {
    final box = GetStorage();
    final token = box.read('token');

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/order'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    final decoded = jsonDecode(response.body);
    print("Create Order Response: $decoded");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return decoded;
    } else {
      throw Exception(
        'Gagal membuat order: ${response.statusCode} - ${response.body}',
      );
    }
  }

  // edit order
  static Future<Map<String, dynamic>> updateOrder(
    int id,
    Map<String, dynamic> body,
  ) async {
    final box = GetStorage();
    final token = box.read('token');

    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/order/$id'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    final decoded = jsonDecode(response.body);
    print("Update Order Response: $decoded");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return decoded;
    } else {
      throw Exception(
        'Gagal update order: ${response.statusCode} - ${response.body}',
      );
    }
  }

  // Update order history/status
  static Future<Map<String, dynamic>> updateOrderHistory({
    required int orderId,
    required String statusCode,
    String? notes,
  }) async {
    final box = GetStorage();
    final token = box.read('token');

    final body = {
      "status_code": statusCode,
      if (notes != null && notes.isNotEmpty) "notes": notes,
    };

    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/order/$orderId/history'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      print('Update History Response: ${response.body}');
      return decoded;
    } else {
      throw Exception(
        'Gagal update status: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
