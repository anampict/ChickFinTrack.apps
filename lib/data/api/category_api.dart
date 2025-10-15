import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/data/api/api_config.dart';
import 'package:get_storage/get_storage.dart';

class CategoryApi {
  //get kategori
  static Future<List<dynamic>> getCategories() async {
    final box = GetStorage();
    final token = box.read('token');
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/categories'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      print(response.body);
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
    final box = GetStorage();
    final token = box.read('token');
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/categories'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
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
    final box = GetStorage();
    final token = box.read('token');
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/categories/$id'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
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
    final box = GetStorage();
    final token = box.read('token');
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/categories/$id'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      print("Gagal delete kategori: ${response.body}");
      throw Exception('Gagal delete kategori (${response.statusCode})');
    }
  }
}
