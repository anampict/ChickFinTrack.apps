import 'package:my_app/data/api/order_api.dart';
import 'package:my_app/data/models/order_model.dart';

class OrderRepository {
  // get semua order
  Future<Map<String, dynamic>> fetchOrders({int page = 1}) async {
    final result = await OrderApi.getOrders(page: page);

    final orders = (result['data'] as List)
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return {
      'orders': orders,
      'pagination':
          result['pagination'], // total, per_page, current_page, last_page
    };
  }

  // get detail order
  Future<OrderModel> getOrderDetail(int id) async {
    final data = await OrderApi.getOrderDetail(id);
    return OrderModel.fromJson(data);
  }

  // tambah order
  Future<OrderModel> createOrder(Map<String, dynamic> body) async {
    final result = await OrderApi.createOrder(body);

    if (result['success'] == true && result['data'] != null) {
      return OrderModel.fromJson(result['data']);
    } else {
      throw Exception(result['message'] ?? 'Gagal membuat pesanan');
    }
  }
}
