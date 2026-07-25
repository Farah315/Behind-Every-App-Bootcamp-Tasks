import 'package:equatable/equatable.dart';

/// Pure domain representation of a product category.
class CategoryEntity extends Equatable {
  const CategoryEntity({required this.slug, required this.name});

  final String slug;
  final String name;

  @override
  List<Object?> get props => [slug, name];
}
