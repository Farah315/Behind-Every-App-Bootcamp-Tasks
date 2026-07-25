import '../../domain/entities/product_entity.dart';

/// Data-layer model responsible for JSON <-> object mapping.
/// Converts to [ProductEntity] before leaving the data layer.
class ProductModel {
  const ProductModel({
    required this.id,
    required this.title,
    required this.brand,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.thumbnail,
  });

  final int id;
  final String title;
  final String brand;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final String thumbnail;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      // Some DummyJSON categories (e.g. groceries) omit a brand.
      brand: json['brand'] as String? ?? json['category'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      thumbnail: json['thumbnail'] as String? ?? '',
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      title: title,
      brand: brand,
      category: category,
      price: price,
      discountPercentage: discountPercentage,
      rating: rating,
      thumbnail: thumbnail,
    );
  }
}
