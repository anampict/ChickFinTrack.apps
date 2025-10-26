class UserModel {
  final int id;
  final String name;
  final String? otherName;
  final String email;
  final String role;
  final String phone;
  final String? avatar;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<AddressModel> addresses;

  UserModel({
    required this.id,
    required this.name,
    this.otherName,
    required this.email,
    required this.role,
    required this.phone,
    this.avatar,
    required this.createdAt,
    required this.updatedAt,
    required this.addresses,
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
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      addresses:
          (json['addresses'] as List<dynamic>?)
              ?.map((e) => AddressModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class AddressModel {
  final int id;
  final String shippingName;
  final String addressLine1;
  final String? addressLine2;
  final String? districtId;
  final String? state;
  final String? cityId;
  final String? city;
  final String? province;
  final String? postalCode;
  final bool isDefault;
  final String createdAt;
  final String updatedAt;

  AddressModel({
    required this.id,
    required this.shippingName,
    required this.addressLine1,
    this.addressLine2,
    this.districtId,
    this.state,
    this.cityId,
    this.city,
    this.province,
    this.postalCode,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? 0,
      shippingName: json['shipping_name'] ?? '',
      addressLine1: json['address_line1'] ?? '',
      addressLine2: json['address_line2'],
      districtId: json['district_id']?.toString(),
      state: json['state'],
      cityId: json['city_id']?.toString(),
      city: json['city'],
      province: json['province'],
      postalCode: json['postal_code'],
      isDefault: json['is_default'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
