class StockModel {
  final int id;
  final String changeType;
  final int quantityChange;
  final int previousStock;
  final int newStock;
  final String? reason;
  final String? notes;
  final DateTime createdAt;

  StockModel({
    required this.id,
    required this.changeType,
    required this.quantityChange,
    required this.previousStock,
    required this.newStock,
    this.reason,
    this.notes,
    required this.createdAt,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      id: json['id'],
      changeType: json['change_type'],
      quantityChange: int.parse(json['quantity_change'].toString()),
      previousStock: int.parse(json['previous_stock'].toString()),
      newStock: int.parse(json['new_stock'].toString()),
      reason: json['reason'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
