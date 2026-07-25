import '../../domain/entities/category_entity.dart';

/// DummyJSON's /products/categories endpoint returns a list of
/// objects: { "slug": "...", "name": "...", "url": "..." }.
class CategoryModel {
  const CategoryModel({required this.slug, required this.name});

  final String slug;
  final String name;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  CategoryEntity toEntity() => CategoryEntity(slug: slug, name: name);
}
