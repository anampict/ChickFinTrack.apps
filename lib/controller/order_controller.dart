import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/order_model.dart';
import '../data/repositories/order_repository.dart';

class OrderController extends GetxController {
  final OrderRepository _repository = OrderRepository();

  var orders = <OrderModel>[].obs;
  var isLoading = false.obs;
  var selectedOrder = Rxn<OrderModel>();
  var pagination = Rxn<Map<String, dynamic>>();

  var isCreating = false.obs;

  var currentPage = 1.obs;

  var isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshOrders();
  }

  // fetch semua order
  Future<void> fetchOrders({int page = 1}) async {
    try {
      isLoading.value = true;

      final result = await _repository.fetchOrders(page: page);
      orders.value = result['orders'];
      pagination.value = result['pagination'];
      currentPage.value = pagination.value?['current_page'] ?? 1;

      print('Orders fetched: ${orders.length}');
      print(
        'Page: ${pagination.value?['current_page']}/${pagination.value?['last_page']}',
      );
    } catch (e) {
      print('Error fetch orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOrders() async {
    currentPage.value = 1;
    orders.clear();
    await fetchOrders(page: 1);
  }

  var isLoadingMore = false.obs;

  get lastPage => null;

  Future<void> loadMoreOrders() async {
    if (isLoadingMore.value) return;

    final current = pagination.value?['current_page'] ?? 1;
    final last = pagination.value?['last_page'] ?? 1;
    if (current >= last) return;

    try {
      isLoadingMore.value = true;
      final nextPage = current + 1;

      final result = await _repository.fetchOrders(page: nextPage);
      final newOrders = result['orders'] as List<OrderModel>;

      orders.addAll(newOrders);
      pagination.value = result['pagination'];
    } catch (e) {
      print('❌ Error load more: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// cari order di list berdasarkan ID
  OrderModel? getOrderById(int id) {
    try {
      return orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  /// fetch seluruh page sampai ketemu (kalau belum ada)
  Future<OrderModel?> fetchOrderById(int id) async {
    // 1. Cek di list yg sudah ada
    OrderModel? exist = getOrderById(id);
    if (exist != null) return exist;

    // 2. Cari ke semua halaman
    int last = pagination.value?['last_page'] ?? 1;

    for (int page = 1; page <= last; page++) {
      await fetchOrders(page: page);
      exist = getOrderById(id);
      if (exist != null) return exist;
    }
    return null;
  }

  /// pilih order
  void selectOrder(int id) {
    selectedOrder.value = getOrderById(id);
  }

  // fetch detail order
  Future<void> fetchOrderDetail(int id) async {
    try {
      isLoading.value = true;
      selectedOrder.value = await _repository.getOrderDetail(id);
    } catch (e) {
      print('Error fetch order detail: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<OrderModel?> createOrder({
    required int userId,
    required int userAddressId,
    required int courierId,
    required String orderDate,
    required int totalAmount,
    required int deposit,
    required List<Map<String, dynamic>> orderItems,
  }) async {
    try {
      isCreating.value = true;

      final body = {
        "user_id": userId,
        "user_address_id": userAddressId,
        "courier_id": courierId,
        "order_date": orderDate,
        "total_amount": totalAmount,
        "deposit": deposit,
        "order_items": orderItems,
      };

      print("Sending Order: $body");

      final result = await _repository.createOrder(body);

      // setelah berhasil: refresh list
      await fetchOrders();

      return result;
    } catch (e) {
      print("Error create order: $e");
      return null;
    } finally {
      isCreating.value = false;
    }
  }

  Future<OrderModel?> updateOrder({
    required int orderId,
    required int userId,
    required int userAddressId,
    required int courierId,
    required String orderDate,
    required int totalAmount,
    required int deposit,
    required List<Map<String, dynamic>> orderItems,
  }) async {
    try {
      isUpdating.value = true;

      final body = {
        "user_id": userId,
        "user_address_id": userAddressId,
        "courier_id": courierId,
        "order_date": orderDate,
        "total_amount": totalAmount,
        "deposit": deposit,
        "order_items": orderItems,
      };

      print("Updating Order ID $orderId: $body");

      final result = await _repository.updateOrder(orderId, body);

      // Update selectedOrder jika sedang di detail
      if (selectedOrder.value?.id == orderId) {
        selectedOrder.value = result;
      }

      // Update di list orders
      final index = orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        orders[index] = result;
      }

      return result;
    } catch (e) {
      print("Error update order: $e");
      return null;
    } finally {
      isUpdating.value = false;
    }
  }

  // Update order status
  Future<bool> updateOrderStatus({
    required int orderId,
    required String statusCode,
    String? notes,
  }) async {
    try {
      isLoading.value = true;

      final success = await _repository.updateOrderHistory(
        orderId: orderId,
        statusCode: statusCode,
        notes: notes,
      );

      if (success) {
        // Refresh detail order setelah update
        await fetchOrderDetail(orderId);

        // Refresh list orders juga
        await refreshOrders();

        Get.snackbar(
          'Berhasil',
          'Status pesanan berhasil diubah',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }

      return success;
    } catch (e) {
      print('Error update order status: $e');
      Get.snackbar(
        'Error',
        'Gagal mengubah status: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
