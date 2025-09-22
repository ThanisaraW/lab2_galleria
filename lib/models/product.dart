class Product {
  final int id;
  final String name;
  final double price;
  final String detail;
  final List<String> images;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.detail,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      detail: json['detail'] ?? '',
      images: json['images'] != null 
        ? List<String>.from(json['images']) 
        : ['https://via.placeholder.com/300x300?text=No+Image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'detail': detail,
      'images': images,
    };
  }

  String get mainImage => images.isNotEmpty ? images.first : 'https://via.placeholder.com/300x300?text=No+Image';
}