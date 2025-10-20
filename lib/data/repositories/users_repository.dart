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
}
