import 'package:get/get.dart';
import '../data/models/order_model.dart';
import '../data/repositories/order_repository.dart';

class OrderController extends GetxController {
  final OrderRepository _repository = OrderRepository();

  var orders = <OrderModel>[].obs;
  var isLoading = false.obs;
  var selectedOrder = Rxn<OrderModel>();
  var pagination = Rxn<Map<String, dynamic>>();

  var currentPage = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
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
