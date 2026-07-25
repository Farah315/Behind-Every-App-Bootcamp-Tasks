import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/category_model.dart';
import '../models/paginated_products_model.dart';

/// Talks to the DummyJSON API and returns raw data-layer models.
/// Knows nothing about the domain layer or Failures — that
/// translation happens one level up, in the repository.
abstract class ProductRemoteDataSource {
  Future<PaginatedProductsModel> fetchProducts({required int limit, required int skip});

  Future<PaginatedProductsModel> searchProducts({
    required String query,
    required int limit,
    required int skip,
  });

  Future<PaginatedProductsModel> fetchProductsByCategory({
    required String categorySlug,
    required int limit,
    required int skip,
  });

  Future<List<CategoryModel>> fetchCategories();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl({required DioClient client}) : _client = client;

  final DioClient _client;

  @override
  Future<PaginatedProductsModel> fetchProducts({required int limit, required int skip}) async {
    final response = await _client.get(
      ApiConstants.products,
      queryParameters: {
        ApiConstants.limitParam: limit,
        ApiConstants.skipParam: skip,
      },
    );
    return PaginatedProductsModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PaginatedProductsModel> searchProducts({
    required String query,
    required int limit,
    required int skip,
  }) async {
    final response = await _client.get(
      ApiConstants.searchProducts,
      queryParameters: {
        ApiConstants.queryParam: query,
        ApiConstants.limitParam: limit,
        ApiConstants.skipParam: skip,
      },
    );
    return PaginatedProductsModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PaginatedProductsModel> fetchProductsByCategory({
    required String categorySlug,
    required int limit,
    required int skip,
  }) async {
    final response = await _client.get(
      ApiConstants.productsByCategory(categorySlug),
      queryParameters: {
        ApiConstants.limitParam: limit,
        ApiConstants.skipParam: skip,
      },
    );
    return PaginatedProductsModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<CategoryModel>> fetchCategories() async {
    final response = await _client.get(ApiConstants.categories);
    final raw = (response.data as List<dynamic>).cast<Map<String, dynamic>>();
    return raw.map(CategoryModel.fromJson).toList();
  }
}
