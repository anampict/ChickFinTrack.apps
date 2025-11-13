class DashboardModel {
  final int totalOrders;
  final double totalRevenue;

  DashboardModel({required this.totalOrders, required this.totalRevenue});

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalOrders: json['total_orders'] ?? 0,
      totalRevenue:
          double.tryParse(json['total_revenue']?.toString() ?? '0') ?? 0.0,
    );
  }

  // Format revenue ke format Rupiah
  String get formattedRevenue {
    return 'Rp. ${totalRevenue.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
