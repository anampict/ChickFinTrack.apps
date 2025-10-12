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
}
