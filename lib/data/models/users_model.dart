class UserModel {
  final int id;
  final String name;
  final String? otherName;
  final String email;
  final String role;
  final String phone;
  final String? avatar;

  UserModel({
    required this.id,
    required this.name,
    this.otherName,
    required this.email,
    required this.role,
    required this.phone,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      otherName: json['other_name'],
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'],
    );
  }
}
