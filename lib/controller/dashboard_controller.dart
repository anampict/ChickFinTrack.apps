import 'package:get/get.dart';
import 'package:my_app/data/models/dashboard_model.dart';
import 'package:my_app/data/repositories/dashboard_repository.dart';

class DashboardController extends GetxController {
  final DashboardRepository _repository = DashboardRepository();

  var dashboard = Rxn<DashboardModel>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardSummary();
  }

  // Fetch dashboard summary
  Future<void> fetchDashboardSummary() async {
    try {
      isLoading.value = true;
      dashboard.value = await _repository.getDashboardSummary();
    } catch (e) {
      print('Error fetch dashboard summary: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat data dashboard',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh dashboard
  Future<void> refreshDashboard() async {
    await fetchDashboardSummary();
  }
}
