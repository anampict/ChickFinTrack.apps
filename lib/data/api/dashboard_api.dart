import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:my_app/data/api/api_config.dart';

class DashboardApi {
  // Get dashboard summary
  static Future<Map<String, dynamic>> getDashboardSummary() async {
    final box = GetStorage();
    final token = box.read('token');

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/dashboard/summary'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      print('Dashboard Summary Response: ${response.body}');
      return decoded['data'];
    } else {
      throw Exception(
        'Gagal ambil dashboard summary: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
