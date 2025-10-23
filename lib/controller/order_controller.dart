import 'package:get/get.dart';
import '../data/models/order_model.dart';
import '../data/repositories/order_repository.dart';

class OrderController extends GetxController {
  final OrderRepository _repository = OrderRepository();

  var orders = <OrderModel>[].obs;
  var isLoading = false.obs;
  var selectedOrder = Rxn<OrderModel>();

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  // fetch semua order
  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      orders.value = await _repository.getAllOrders();
    } catch (e) {
      print('Error fetch orders: $e');
    } finally {
      isLoading.value = false;
    }
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
}
