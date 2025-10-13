class ApiConfig {
  static const String baseUrl = 'https://chickfintrack.id/api';
  static const String token =
      '10|RXa4FOxzgvHRqIhG3KWXnLx8GZXBJr17SF5eEuhPcc39a073';

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
}
