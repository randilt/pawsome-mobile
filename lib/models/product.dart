class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String? description;
  final String? categoryId;
  final int stockQuantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.description,
    this.categoryId,
    this.stockQuantity = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price']),
      imageUrl: json['image_url'],
      description: json['description'],
      categoryId: json['category_id'],
      stockQuantity: int.parse(json['stock_quantity']),
    );
  }
}
