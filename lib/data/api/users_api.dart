import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_app/data/api/api_config.dart';
import 'package:my_app/data/models/users_model.dart';

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

  //tambah alamat
  static Future<Map<String, dynamic>> createAddress({
    required int userId,
    required Map<String, dynamic> body,
  }) async {
    final box = GetStorage();
    final token = box.read('token');

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/users/$userId/address'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal menambah alamat: ${response.body}');
    }
  }

  //update alamat
  static Future<Map<String, dynamic>> updateAddress({
    required int userId,
    required int addressId,
    required Map<String, dynamic> body,
  }) async {
    final box = GetStorage();
    final token = box.read('token');

    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/users/$userId/address/$addressId'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal update alamat: ${response.body}');
    }
  }

  //fetch cities
  static Future<List<dynamic>> fetchCities() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/cities'),
      headers: {...ApiConfig.headers},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']; // list of cities
    } else {
      throw Exception('Gagal mengambil daftar kota: ${response.body}');
    }
  }

  //fetch districts
  static Future<List<dynamic>> fetchDistricts(int cityId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/cities/$cityId/districts'),
      headers: {...ApiConfig.headers},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Gagal mengambil daftar kecamatan: ${response.body}');
    }
  }

  // Hapus alamat
  static Future<void> deleteAddress({
    required int userId,
    required int addressId,
  }) async {
    final box = GetStorage();
    final token = box.read('token');

    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/users/$userId/address/$addressId'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus alamat: ${response.body}');
    }
  }

  // Get user balance
  static Future<BalanceModel> getUserBalance(int userId) async {
    final box = GetStorage();
    final token = box.read('token');

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/users/$userId/balance'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return BalanceModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat saldo: ${response.body}');
    }
  }

  // Top up user balance
  static Future<Map<String, dynamic>> topUpBalance({
    required int userId,
    required double amount,
    String? description,
  }) async {
    final box = GetStorage();
    final token = box.read('token');

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/users/$userId/top-up'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'amount': amount,
        'description': description ?? 'top up',
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal top up saldo: ${response.body}');
    }
  }

  // Get user credits
  static Future<Map<String, dynamic>> getUserCredits({
    required int userId,
    int page = 1,
  }) async {
    final box = GetStorage();
    final token = box.read('token');

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/users/$userId/credit?page=$page'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal memuat data kredit: ${response.body}');
    }
  }

  // Allocate balance to order credit
  static Future<Map<String, dynamic>> allocateCredit({
    required int userId,
    required int orderCreditId,
    required double amount,
    String? description,
  }) async {
    final box = GetStorage();
    final token = box.read('token');

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/users/$userId/allocation'),
      headers: {
        ...ApiConfig.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'order_credit_id': orderCreditId,
        'amount': amount,
        'description': description ?? 'bayar',
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengalokasikan saldo: ${response.body}');
    }
  }
}
