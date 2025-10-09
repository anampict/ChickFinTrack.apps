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
  //get kategori
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

  //tambah kategori
  static Future<Map<String, dynamic>> addCategory({
    required String name,
    required String description,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/categories'),
      headers: _headers,
      body: jsonEncode({"name": name, "description": description}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      // responsenya kemungkinan object kategori baru
      return jsonDecode(response.body);
    } else {
      print("Gagal menambahkan kategori: ${response.body}");
      throw Exception('Gagal menambahkan kategori (${response.statusCode})');
    }
  }

  // edit kategori
  static Future<Map<String, dynamic>> updateCategory({
    required int id,
    required String name,
    required String description,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/categories/$id'),
      headers: _headers,
      body: jsonEncode({"name": name, "description": description}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Gagal update kategori: ${response.body}");
      throw Exception('Gagal update kategori (${response.statusCode})');
    }
  }

  // delete kategori
  static Future<void> deleteCategory(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/categories/$id'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      print("Gagal delete kategori: ${response.body}");
      throw Exception('Gagal delete kategori (${response.statusCode})');
    }
  }
}
