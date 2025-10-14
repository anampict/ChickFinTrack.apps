class CategoryModel {
  final int id;
  final String? name;
  final String? description;
  final int productsCount;

  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    required this.productsCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'] as String?,
      description: json['description'],
      productsCount: int.tryParse(json['products_count'].toString()) ?? 0,
    );
  }
}
