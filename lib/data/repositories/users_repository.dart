import 'package:my_app/data/api/users_api.dart';
import 'package:my_app/data/models/users_model.dart';

class UserRepository {
  // get semua pengguna
  Future<Map<String, dynamic>> getUsers({int page = 1}) async {
    final data = await UserApi.getUsers(page: page);

    final users = (data['data'] as List)
        .map((e) => UserModel.fromJson(e))
        .toList();

    final meta = data['meta'] ?? {};
    final lastPage = meta['last_page'] ?? 1;

    return {'users': users, 'last_page': lastPage};
  }

  // tambah pengguna
  Future<UserModel> createUser(Map<String, dynamic> data) async {
    final result = await UserApi.createUser(data);
    final userData = result['data'];
    return UserModel.fromJson(userData);
  }

  //get user by id
  Future<UserModel> getUserById(int id) async {
    final data = await UserApi.getUserById(id);
    final userData = data['data'];
    return UserModel.fromJson(userData);
  }

  // update user
  Future<UserModel> updateUser(int id, Map<String, dynamic> data) async {
    final result = await UserApi.updateUser(id, data);
    final userData = result['data'];
    return UserModel.fromJson(userData);
  }

  //tambah alamt
  Future<Map<String, dynamic>> createAddress({
    required int userId,
    required Map<String, dynamic> data,
  }) async {
    final result = await UserApi.createAddress(userId: userId, body: data);
    return result['data'];
  }

  // update alamat
  Future<Map<String, dynamic>> updateAddress({
    required int userId,
    required int addressId,
    required Map<String, dynamic> data,
  }) async {
    final result = await UserApi.updateAddress(
      userId: userId,
      addressId: addressId,
      body: data,
    );

    return result['data'];
  }

  //fetch alamat
  Future<List<dynamic>> fetchCities() async {
    return await UserApi.fetchCities();
  }

  Future<List<dynamic>> fetchDistricts(int cityId) async {
    return await UserApi.fetchDistricts(cityId);
  }

  // Hapus alamat
  Future<void> deleteAddress({
    required int userId,
    required int addressId,
  }) async {
    await UserApi.deleteAddress(userId: userId, addressId: addressId);
  }
}
