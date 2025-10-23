import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_app/data/api/api_config.dart';

class UserApi {
  // get semua user
  static Future<Map<String, dynamic>> getUsers({int page = 1}) async {
    final box = GetStorage();
    final token = box.read('token');

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/users?page=$page'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal memuat data user: ${response.body}');
    }
  }

  //tambah user
  static Future<Map<String, dynamic>> createUser(
    Map<String, dynamic> body,
  ) async {
    final box = GetStorage();
    final token = box.read('token');

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/users'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal menambah user: ${response.body}');
    }
  }

  // get detail
  static Future<Map<String, dynamic>> getUserById(int id) async {
    final box = GetStorage();
    final token = box.read('token');

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/users/$id'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal memuat detail user: ${response.body}');
    }
  }

  // update user
  static Future<Map<String, dynamic>> updateUser(
    int id,
    Map<String, dynamic> body,
  ) async {
    final box = GetStorage();
    final token = box.read('token');

    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/users/$id'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal memperbarui user: ${response.body}');
    }
  }
}
