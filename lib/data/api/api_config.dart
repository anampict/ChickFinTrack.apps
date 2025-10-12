class ApiConfig {
  static const String baseUrl = 'https://chickfintrack.id/api';
  static const String token =
      '7|wbFhlxBMMZaVYqJUCyul7FKzYd9CnbXxm0vvwdq0744c9f54';

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
}
