class ApiConfig {
  static const String baseUrl = 'https://chickfintrack.id/api';
  static const String token =
      '9|jZbaaejEBLJkMN2Bs4PvEmh37XfiSawGNcC9lPEV81dcc21f';

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
}
