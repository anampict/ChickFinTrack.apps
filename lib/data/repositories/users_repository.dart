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
}
