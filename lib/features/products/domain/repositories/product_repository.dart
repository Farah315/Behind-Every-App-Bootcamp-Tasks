import '../entities/category_entity.dart';
import '../entities/paginated_products_entity.dart';

/// Contract the presentation layer (BLoC) depends on.
/// The data layer provides the concrete implementation.
/// No use-case layer here on purpose — the BLoC talks to this
/// repository directly, keeping the project small and focused.
abstract class ProductRepository {
  /// Fetches a page of all products.
  Future<PaginatedProductsEntity> getProducts({
    required int limit,
    required int skip,
  });

  /// Searches products by [query], paginated the same way as
  /// [getProducts].
  Future<PaginatedProductsEntity> searchProducts({
    required String query,
    required int limit,
    required int skip,
  });

  /// Fetches products belonging to [categorySlug], paginated.
  Future<PaginatedProductsEntity> getProductsByCategory({
    required String categorySlug,
    required int limit,
    required int skip,
  });

  /// Fetches the list of available categories.
  Future<List<CategoryEntity>> getCategories();
}
