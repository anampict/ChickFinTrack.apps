import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryApi {
  static const String baseUrl = 'https://chickfintrack.id/api';
  static const String token =
      '2|OBEsReQTifb5yBvl14LbS2roCvgl5J8942vXnHmu2971a53e';

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  static Future<List<dynamic>> getCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['data'];
    } else {
      throw Exception(
        'Gagal ambil kategori: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
