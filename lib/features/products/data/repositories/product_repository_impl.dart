import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/paginated_products_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

/// Concrete implementation of [ProductRepository].
/// Bridges the data source (raw models) with the domain layer
/// (entities), and translates transport errors into [Failure]s.
class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({required ProductRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final ProductRemoteDataSource _remoteDataSource;

  @override
  Future<PaginatedProductsEntity> getProducts({required int limit, required int skip}) {
    return _guard(() async {
      final model = await _remoteDataSource.fetchProducts(limit: limit, skip: skip);
      return model.toEntity();
    });
  }

  @override
  Future<PaginatedProductsEntity> searchProducts({
    required String query,
    required int limit,
    required int skip,
  }) {
    return _guard(() async {
      final model = await _remoteDataSource.searchProducts(query: query, limit: limit, skip: skip);
      return model.toEntity();
    });
  }

  @override
  Future<PaginatedProductsEntity> getProductsByCategory({
    required String categorySlug,
    required int limit,
    required int skip,
  }) {
    return _guard(() async {
      final model = await _remoteDataSource.fetchProductsByCategory(
        categorySlug: categorySlug,
        limit: limit,
        skip: skip,
      );
      return model.toEntity();
    });
  }

  @override
  Future<List<CategoryEntity>> getCategories() {
    return _guard(() async {
      final models = await _remoteDataSource.fetchCategories();
      return models.map((m) => m.toEntity()).toList();
    });
  }

  /// Centralizes try/catch + error mapping so every method above
  /// stays a one-liner.
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw const NetworkFailure();
      }
      throw const ServerFailure();
    } catch (_) {
      throw const UnknownFailure();
    }
  }
}
