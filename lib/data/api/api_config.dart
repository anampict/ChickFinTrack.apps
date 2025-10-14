import 'package:get_storage/get_storage.dart';

class ApiConfig {
  static const String baseUrl = 'https://chickfintrack.id/api';

  static Map<String, String> get headers {
    final box = GetStorage();
    final token = box.read('token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }
}
