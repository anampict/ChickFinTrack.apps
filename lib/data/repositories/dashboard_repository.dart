import '../api/dashboard_api.dart';
import '../models/dashboard_model.dart';

class DashboardRepository {
  // Get dashboard summary
  Future<DashboardModel> getDashboardSummary() async {
    final data = await DashboardApi.getDashboardSummary();
    print("Data dashboard dari API: $data");
    return DashboardModel.fromJson(data);
  }
}
