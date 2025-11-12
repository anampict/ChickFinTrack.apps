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

class BalanceModel {
  final String currentBalance;
  final String availableBalance;
  final String reservedBalance;

  BalanceModel({
    required this.currentBalance,
    required this.availableBalance,
    required this.reservedBalance,
  });

  factory BalanceModel.fromJson(Map<String, dynamic> json) {
    return BalanceModel(
      currentBalance: json['current_balance']?.toString() ?? '0',
      availableBalance: json['available_balance']?.toString() ?? '0',
      reservedBalance: json['reserved_balance']?.toString() ?? '0',
    );
  }

  // Helper untuk format currency
  String get formattedCurrentBalance => formatCurrency(currentBalance);
  String get formattedAvailableBalance => formatCurrency(availableBalance);
  String get formattedReservedBalance => formatCurrency(reservedBalance);

  static String formatCurrency(String amount) {
    final value = double.tryParse(amount) ?? 0;
    return 'Rp ${value.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}

class AddressModel {
  final int id;
  final String shippingName;
  final String addressLine1;
  final String? addressLine2;
  final String? districtId;
  final String? district; // nama kecamatan
  final String? districtName; // nama kecamatan (alternatif)
  final String? cityId;
  final String? city;
  final String? province;
  final String? postalCode;
  final String? phone;
  final bool isDefault;
  final String createdAt;
  final String updatedAt;

  AddressModel({
    required this.id,
    required this.shippingName,
    required this.addressLine1,
    this.addressLine2,
    this.districtId,
    this.district,
    this.districtName,
    this.cityId,
    this.city,
    this.province,
    this.postalCode,
    this.phone,
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
      district: json['district'],
      districtName: json['district_name'] ?? json['district'],
      cityId: json['city_id']?.toString(),
      city: json['city'],
      province: json['province'],
      postalCode: json['postal_code'],
      phone: json['phone'],
      isDefault: json['is_default'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
