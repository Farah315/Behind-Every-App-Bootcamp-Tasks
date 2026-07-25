import 'package:equatable/equatable.dart';

/// Pure domain representation of a product — no JSON, no API
/// concerns. This is what the UI and BLoC work with.
class ProductEntity extends Equatable {
  const ProductEntity({
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

  /// Price after applying [discountPercentage], rounded to 2 decimals.
  double get discountedPrice =>
      double.parse((price - (price * discountPercentage / 100)).toStringAsFixed(2));

  bool get hasDiscount => discountPercentage > 0;

  @override
  List<Object?> get props => [id, title, brand, category, price, discountPercentage, rating, thumbnail];
}
