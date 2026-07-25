import 'package:equatable/equatable.dart';
import 'product_entity.dart';

/// Wraps a single page of products together with the metadata
/// needed to build pagination controls (total count, current
/// skip/limit) without the UI needing to know about API params.
class PaginatedProductsEntity extends Equatable {
  const PaginatedProductsEntity({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  final List<ProductEntity> products;
  final int total;
  final int skip;
  final int limit;

  int get currentPage => (skip / limit).floor() + 1;

  int get totalPages => (total / limit).ceil().clamp(1, double.infinity).toInt();

  bool get hasNextPage => skip + limit < total;

  bool get hasPreviousPage => skip > 0;

  @override
  List<Object?> get props => [products, total, skip, limit];
}
