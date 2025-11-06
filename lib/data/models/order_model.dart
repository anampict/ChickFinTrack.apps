// class OrderModel {
//   final int id;
//   final String orderNumber;
//   final int userId;
//   final int userAddressId;
//   final int courierId;
//   final String orderDate;
//   final int totalAmount;
//   final int allocatedAmount;
//   final int remainingAmount;
//   final dynamic deposit;
//   final UserModel? user;
//   final CourierModel? courier;
//   final List<OrderItemModel>? orderItems;
//   final OrderHistoryModel? activeHistory;
//   final List<OrderHistoryModel>? orderHistories;

//   OrderModel({
//     required this.id,
//     required this.orderNumber,
//     required this.userId,
//     required this.userAddressId,
//     required this.courierId,
//     required this.orderDate,
//     required this.totalAmount,
//     required this.allocatedAmount,
//     required this.remainingAmount,
//     this.deposit,
//     this.user,
//     this.courier,
//     this.orderItems,
//     this.activeHistory,
//     this.orderHistories,
//   });

//   factory OrderModel.fromJson(Map<String, dynamic> json) {
//     return OrderModel(
//       id: json['id'],
//       orderNumber: json['order_number'] ?? '',
//       userId: int.tryParse(json['user_id'].toString()) ?? 0,
//       userAddressId: int.tryParse(json['user_address_id'].toString()) ?? 0,
//       courierId: int.tryParse(json['courier_id'].toString()) ?? 0,
//       orderDate: json['order_date'] ?? '',
//       totalAmount: json['total_amount'] ?? 0,
//       allocatedAmount: json['allocated_amount'] ?? 0,
//       remainingAmount: json['remaining_amount'] ?? 0,
//       deposit: json['deposit'],
//       user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
//       courier: json['courier'] != null
//           ? CourierModel.fromJson(json['courier'])
//           : null,
//       orderItems: json['order_items'] != null
//           ? (json['order_items'] as List)
//                 .map((e) => OrderItemModel.fromJson(e))
//                 .toList()
//           : [],
//       activeHistory: json['active_history'] != null
//           ? OrderHistoryModel.fromJson(json['active_history'])
//           : null,
//       orderHistories: json['order_histories'] != null
//           ? (json['order_histories'] as List)
//                 .map((e) => OrderHistoryModel.fromJson(e))
//                 .toList()
//           : [],
//     );
//   }
// }

class OrderModel {
  final int id;
  final String orderNumber;
  final int userId;
  final int userAddressId;
  final int courierId;
  final String orderDate;
  final double totalAmount;
  final double allocatedAmount;
  final double remainingAmount;
  final dynamic deposit;
  final UserModel? user;
  final CourierModel? courier;
  final List<OrderItemModel>? orderItems;
  final OrderHistoryModel? activeHistory;
  final List<OrderHistoryModel>? orderHistories;

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
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: toIntSafe(json['id']),
      orderNumber: json['order_number'] ?? '',
      userId: toIntSafe(json['user_id']),
      userAddressId: toIntSafe(json['user_address_id']),
      courierId: toIntSafe(json['courier_id']),
      orderDate: json['order_date'] ?? '',
      totalAmount: toDoubleSafe(json['total_amount']),
      allocatedAmount: toDoubleSafe(json['allocated_amount']),
      remainingAmount: toDoubleSafe(json['remaining_amount']),
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
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    role: json['role'] ?? '',
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

// class OrderItemModel {
//   final int id;
//   final int productId;
//   final int quantity;
//   final int priceAtPurchase;
//   final int subtotal;
//   final ProductModel? product;

//   OrderItemModel({
//     required this.id,
//     required this.productId,
//     required this.quantity,
//     required this.priceAtPurchase,
//     required this.subtotal,
//     this.product,
//   });

//   factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
//     id: json['id'],
//     productId: int.tryParse(json['product_id'].toString()) ?? 0,
//     quantity: int.tryParse(json['quantity'].toString()) ?? 0,
//     priceAtPurchase: json['price_at_purchase'] ?? 0,
//     subtotal: json['subtotal'] ?? 0,
//     product: json['product'] != null
//         ? ProductModel.fromJson(json['product'])
//         : null,
//   );
// }

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
