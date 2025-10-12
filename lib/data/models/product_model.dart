class ProductModel {
  final int id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String sku;
  final int categoryId;
  final String? imageUrl;
  final double weight;
  final String? dimensions;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProductCategory? category;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    required this.sku,
    required this.categoryId,
    this.imageUrl,
    required this.weight,
    this.dimensions,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      stock: int.parse(json['stock'].toString()),
      sku: json['sku'],
      categoryId: int.parse(json['category_id'].toString()),
      imageUrl: json['image_url'],
      weight: double.parse(json['weight'].toString()),
      dimensions: json['dimensions'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      category: json['category'] != null
          ? ProductCategory.fromJson(json['category'])
          : null,
    );
  }
}

class ProductCategory {
  final int id;
  final String name;
  final String? description;

  ProductCategory({required this.id, required this.name, this.description});

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
