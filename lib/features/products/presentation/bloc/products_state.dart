import 'package:equatable/equatable.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';

enum ProductsStatus { initial, loading, success, failure }

/// Single immutable state object for the whole Products page.
/// Kept flat on purpose (one state class instead of a hierarchy)
/// since the page has one screen and a handful of orthogonal
/// pieces of state (list, categories, pagination, search).
class ProductsState extends Equatable {
  const ProductsState({
    this.status = ProductsStatus.initial,
    this.products = const [],
    this.categories = const [],
    this.selectedCategorySlug,
    this.searchQuery = '',
    this.currentPage = 1,
    this.totalPages = 1,
    this.errorMessage,
  });

  final ProductsStatus status;
  final List<ProductEntity> products;
  final List<CategoryEntity> categories;
  final String? selectedCategorySlug;
  final String searchQuery;
  final int currentPage;
  final int totalPages;
  final String? errorMessage;

  bool get isSearching => searchQuery.trim().isNotEmpty;

  ProductsState copyWith({
    ProductsStatus? status,
    List<ProductEntity>? products,
    List<CategoryEntity>? categories,
    String? selectedCategorySlug,
    bool clearSelectedCategory = false,
    String? searchQuery,
    int? currentPage,
    int? totalPages,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategorySlug:
          clearSelectedCategory ? null : (selectedCategorySlug ?? this.selectedCategorySlug),
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        categories,
        selectedCategorySlug,
        searchQuery,
        currentPage,
        totalPages,
        errorMessage,
      ];
}
