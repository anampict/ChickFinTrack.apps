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
}
