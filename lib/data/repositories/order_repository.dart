import 'package:my_app/data/api/order_api.dart';
import 'package:my_app/data/models/order_model.dart';

class OrderRepository {
  // get semua order
  Future<List<OrderModel>> getAllOrders() async {
    final data = await OrderApi.getOrders();
    print("Data order dari API: $data");
    return (data as List).map((e) => OrderModel.fromJson(e)).toList();
  }

  // get detail order
  Future<OrderModel> getOrderDetail(int id) async {
    final data = await OrderApi.getOrderDetail(id);
    return OrderModel.fromJson(data);
  }
}
