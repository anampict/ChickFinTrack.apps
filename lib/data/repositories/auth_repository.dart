import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_config.dart';

class AuthRepository {
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return {'message': 'Email atau password salah'};
      }
    } catch (e) {
      print('Error login: $e');
      return null;
    }
  }
}
