import 'package:flutter/material.dart';

class CreditModel {
  final int id;
  final String orderId;
  final String customerId;
  final String totalAmount;
  final String allocatedAmount;
  final String remainingAmount;
  final String status;
  final String expiresAt;
  final String createdAt;
  final String updatedAt;
  final CreditOrderModel? order;

  CreditModel({
    required this.id,
    required this.orderId,
    required this.customerId,
    required this.totalAmount,
    required this.allocatedAmount,
    required this.remainingAmount,
    required this.status,
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
    this.order,
  });

  factory CreditModel.fromJson(Map<String, dynamic> json) {
    return CreditModel(
      id: json['id'] ?? 0,
      orderId: json['order_id']?.toString() ?? '',
      customerId: json['customer_id']?.toString() ?? '',
      totalAmount: json['total_amount']?.toString() ?? '0',
      allocatedAmount: json['allocated_amount']?.toString() ?? '0',
      remainingAmount: json['remaining_amount']?.toString() ?? '0',
      status: json['status'] ?? '',
      expiresAt: json['expires_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      order: json['order'] != null
          ? CreditOrderModel.fromJson(json['order'])
          : null,
    );
  }

  // Helper untuk format currency
  String get formattedTotalAmount => _formatCurrency(totalAmount);
  String get formattedAllocatedAmount => _formatCurrency(allocatedAmount);
  String get formattedRemainingAmount => _formatCurrency(remainingAmount);

  static String _formatCurrency(String amount) {
    final value = double.tryParse(amount) ?? 0;
    return 'Rp ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  // Helper untuk format tanggal
  String get formattedExpiresAt => _formatDate(expiresAt);
  String get formattedCreatedAt => _formatDate(createdAt);

  static String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  // Helper untuk status label
  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Menunggu';
      case 'paid':
        return 'Lunas';
      case 'partial':
        return 'Sebagian';
      case 'expired':
        return 'Kadaluarsa';
      default:
        return status;
    }
  }

  // Helper untuk status color
  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'paid':
        return Colors.green;
      case 'partial':
        return Colors.blue;
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class CreditOrderModel {
  final int id;
  final String orderNumber;
  final String userId;
  final String userAddressId;
  final String totalAmount;
  final String deposit;
  final bool cash;
  final bool topUped;
  final String? trackingNumber;
  final String orderDate;
  final String createdAt;
  final String updatedAt;
  final String? courierId;

  CreditOrderModel({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.userAddressId,
    required this.totalAmount,
    required this.deposit,
    required this.cash,
    required this.topUped,
    this.trackingNumber,
    required this.orderDate,
    required this.createdAt,
    required this.updatedAt,
    this.courierId,
  });

  factory CreditOrderModel.fromJson(Map<String, dynamic> json) {
    return CreditOrderModel(
      id: json['id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      userId: json['user_id']?.toString() ?? '',
      userAddressId: json['user_address_id']?.toString() ?? '',
      totalAmount: json['total_amount']?.toString() ?? '0',
      deposit: json['deposit']?.toString() ?? '0',
      cash: json['cash'] ?? false,
      topUped: json['top_uped'] ?? false,
      trackingNumber: json['tracking_number'],
      orderDate: json['order_date'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      courierId: json['courier_id']?.toString(),
    );
  }
}
