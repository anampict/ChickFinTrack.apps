import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:my_app/data/api/api_config.dart';

class ProductApi {
  static final box = GetStorage();

  // get semua produk
  static Future<List<dynamic>> getProducts() async {
    final token = box.read('token');
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/products'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      print(response.body); // untuk debugging
      return decoded['data'];
    } else {
      throw Exception(
        'Gagal ambil produk: ${response.statusCode} - ${response.body}',
      );
    }
  }

  // create product
  static Future<Map<String, dynamic>> createProduct(
    Map<String, dynamic> body,
  ) async {
    final token = box.read('token');
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/products'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      print(' Product created: $decoded');
      return decoded['data'];
    } else {
      print('Gagal create product: ${response.statusCode} - ${response.body}');
      throw Exception('Gagal create product');
    }
  }

  //edit produk
  static Future<Map<String, dynamic>> updateProduct(
    int id,
    Map<String, dynamic> body,
  ) async {
    final token = box.read('token');
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/products/$id'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      print(' Product updated: $decoded');
      return decoded['data'];
    } else {
      print('Gagal update product: ${response.statusCode} - ${response.body}');
      throw Exception('Gagal update product');
    }
  }
}
