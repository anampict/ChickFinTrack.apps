import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/data/api/api_config.dart';

class AuthApi {
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/login');

    final response = await http.post(
      url,
      headers: ApiConfig.headers,
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Simpan token ke GetStorage
      final box = GetStorage();
      box.write('token', data['token']);

      return {'success': true, 'user': data['user'], 'token': data['token']};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Login gagal'};
    }
  }
}
