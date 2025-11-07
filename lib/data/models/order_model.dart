import 'package:my_app/data/models/users_model.dart';

class OrderModel {
  final int id;
  final String orderNumber;
  final int userId;
  // final int userAddressId;
  final String userAddressId;
  final int courierId;
  final String orderDate;
  final int totalAmount;
  final int allocatedAmount;
  final int remainingAmount;
  final dynamic deposit;
  final UserModel? user;
  final CourierModel? courier;
  final List<OrderItemModel>? orderItems;
  final OrderHistoryModel? activeHistory;
  final List<OrderHistoryModel>? orderHistories;
  final AddressModel? userAddress;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.userAddressId,
    required this.courierId,
    required this.orderDate,
    required this.totalAmount,
    required this.allocatedAmount,
    required this.remainingAmount,
    this.deposit,
    this.user,
    this.courier,
    this.orderItems,
    this.activeHistory,
    this.orderHistories,
    this.userAddress,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    print("Order JSON: ${json}");
    return OrderModel(
      id: json['id'],
      orderNumber: json['order_number'] ?? '',
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      // userAddressId: int.tryParse(json['user_address_id'].toString()) ?? 0,
      userAddressId: json['user_address_id']?.toString() ?? '',

      courierId: int.tryParse(json['courier_id'].toString()) ?? 0,
      orderDate: json['order_date'] ?? '',
      totalAmount: json['total_amount'] ?? 0,
      allocatedAmount: json['allocated_amount'] ?? 0,
      remainingAmount: json['remaining_amount'] ?? 0,
      deposit: json['deposit'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      courier: json['courier'] != null
          ? CourierModel.fromJson(json['courier'])
          : null,
      orderItems: json['order_items'] != null
          ? (json['order_items'] as List)
                .map((e) => OrderItemModel.fromJson(e))
                .toList()
          : [],
      activeHistory: json['active_history'] != null
          ? OrderHistoryModel.fromJson(json['active_history'])
          : null,
      orderHistories: json['order_histories'] != null
          ? (json['order_histories'] as List)
                .map((e) => OrderHistoryModel.fromJson(e))
                .toList()
          : [],
      userAddress: json['user_address'] != null
          ? AddressModel.fromJson(json['user_address'])
          : null,
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final List<AddressModel> addresses;
  final String addressLine1;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.addresses,
    required this.addressLine1,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    role: json['role'] ?? '',
    addresses:
        (json['addresses'] as List<dynamic>?)
            ?.map((e) => AddressModel.fromJson(e))
            .toList() ??
        [],
    addressLine1: json['address_line1'] ?? '',
  );
}

class CourierModel {
  final int id;
  final String name;
  final String email;

  CourierModel({required this.id, required this.name, required this.email});

  factory CourierModel.fromJson(Map<String, dynamic> json) => CourierModel(
    id: json['id'],
    name: json['name'] ?? '',
    email: json['email'] ?? '',
  );
}

class OrderItemModel {
  final int id;
  final int productId;
  final int quantity;
  final double priceAtPurchase;
  final double subtotal;
  final ProductModel? product;

  OrderItemModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.priceAtPurchase,
    required this.subtotal,
    this.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
    id: toIntSafe(json['id']),
    productId: toIntSafe(json['product_id']),
    quantity: toIntSafe(json['quantity']),
    priceAtPurchase: toDoubleSafe(json['price_at_purchase']),
    subtotal: toDoubleSafe(json['subtotal']),
    product: json['product'] != null
        ? ProductModel.fromJson(json['product'])
        : null,
  );
}

class ProductModel {
  final int id;
  final String name;
  final double price;

  ProductModel({required this.id, required this.name, required this.price});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rawPrice = json['price'];

    // Convert langsung → double
    final priceDouble = double.tryParse(rawPrice.toString()) ?? 0.0;

    return ProductModel(id: json['id'], name: json['name'], price: priceDouble);
  }
}

class OrderHistoryModel {
  final int id;
  final String statusCode;
  final String statusName;
  final String notes;
  final bool? isActive;
  final String createdAt;

  OrderHistoryModel({
    required this.id,
    required this.statusCode,
    required this.statusName,
    required this.notes,
    this.isActive,
    required this.createdAt,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) =>
      OrderHistoryModel(
        id: json['id'],
        statusCode: json['status_code'] ?? '',
        statusName: json['status_name'] ?? '',
        notes: json['notes'] ?? '',
        isActive: json['is_active'],
        createdAt: json['created_at'] ?? '',
      );
}

int toIntSafe(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

double toDoubleSafe(dynamic v) {
  if (v == null) return 0;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}
