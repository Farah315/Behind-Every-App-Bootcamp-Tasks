import '../../domain/entities/paginated_products_entity.dart';
import 'product_model.dart';

/// Maps DummyJSON's paginated products response:
/// { "products": [...], "total": n, "skip": n, "limit": n }
class PaginatedProductsModel {
  const PaginatedProductsModel({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  factory PaginatedProductsModel.fromJson(Map<String, dynamic> json) {
    final rawProducts = (json['products'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    return PaginatedProductsModel(
      products: rawProducts.map(ProductModel.fromJson).toList(),
      total: json['total'] as int? ?? 0,
      skip: json['skip'] as int? ?? 0,
      limit: json['limit'] as int? ?? rawProducts.length,
    );
  }

  PaginatedProductsEntity toEntity() {
    return PaginatedProductsEntity(
      products: products.map((p) => p.toEntity()).toList(),
      total: total,
      skip: skip,
      limit: limit,
    );
  }
}
