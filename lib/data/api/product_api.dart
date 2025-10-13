import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/data/api/api_config.dart';

class ProductApi {
  // get semua produk
  static Future<List<dynamic>> getProducts() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/products'),
      headers: ApiConfig.headers,
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
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/products'),
      headers: ApiConfig.headers,
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
}
