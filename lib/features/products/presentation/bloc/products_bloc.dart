import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/paginated_products_entity.dart';
import '../../domain/repositories/product_repository.dart';
import 'products_event.dart';
import 'products_state.dart';

const _searchDebounceDuration = Duration(milliseconds: 400);

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc({required ProductRepository repository})
      : _repository = repository,
        super(const ProductsState()) {
    on<ProductsStarted>(_onStarted);
    on<ProductsCategorySelected>(_onCategorySelected);
    on<ProductsNextPageRequested>(_onNextPageRequested);
    on<ProductsPreviousPageRequested>(_onPreviousPageRequested);

    // Debounce: only the latest search event within the window
    // fires the request — this satisfies the bonus requirement.
    on<ProductsSearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: (events, mapper) => events.debounce(_searchDebounceDuration).switchMap(mapper),
    );
  }

  final ProductRepository _repository;

  Future<void> _onStarted(ProductsStarted event, Emitter<ProductsState> emit) async {
    await _fetchPage(skip: 0, emit: emit);
  }

  Future<void> _onSearchQueryChanged(
    ProductsSearchQueryChanged event,
    Emitter<ProductsState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
    await _fetchPage(skip: 0, emit: emit);
  }

  Future<void> _onCategorySelected(
    ProductsCategorySelected event,
    Emitter<ProductsState> emit,
  ) async {
    emit(state.copyWith(
      selectedCategorySlug: event.categorySlug,
      clearSelectedCategory: event.categorySlug == null,
    ));
    await _fetchPage(skip: 0, emit: emit);
  }

  Future<void> _onNextPageRequested(
    ProductsNextPageRequested event,
    Emitter<ProductsState> emit,
  ) async {
    if (state.currentPage >= state.totalPages) return;
    final nextSkip = state.currentPage * ApiConstants.defaultPageLimit;
    await _fetchPage(skip: nextSkip, emit: emit);
  }

  Future<void> _onPreviousPageRequested(
    ProductsPreviousPageRequested event,
    Emitter<ProductsState> emit,
  ) async {
    if (state.currentPage <= 1) return;
    final previousSkip = (state.currentPage - 2) * ApiConstants.defaultPageLimit;
    await _fetchPage(skip: previousSkip, emit: emit);
  }

  /// Single funnel every event goes through: picks the right
  /// repository call based on current search/category state, then
  /// updates the state consistently. Also lazily loads categories
  /// once, on first successful fetch.
  Future<void> _fetchPage({required int skip, required Emitter<ProductsState> emit}) async {
    emit(state.copyWith(status: ProductsStatus.loading, clearError: true));

    try {
      final PaginatedProductsEntity page;
      if (state.isSearching) {
        page = await _repository.searchProducts(
          query: state.searchQuery.trim(),
          limit: ApiConstants.defaultPageLimit,
          skip: skip,
        );
      } else if (state.selectedCategorySlug != null) {
        page = await _repository.getProductsByCategory(
          categorySlug: state.selectedCategorySlug!,
          limit: ApiConstants.defaultPageLimit,
          skip: skip,
        );
      } else {
        page = await _repository.getProducts(
          limit: ApiConstants.defaultPageLimit,
          skip: skip,
        );
      }

      var categories = state.categories;
      if (categories.isEmpty) {
        categories = await _repository.getCategories();
      }

      emit(state.copyWith(
        status: ProductsStatus.success,
        products: page.products,
        categories: categories,
        currentPage: page.currentPage,
        totalPages: page.totalPages,
      ));
    } on Failure catch (f) {
      emit(state.copyWith(status: ProductsStatus.failure, errorMessage: f.message));
    } catch (_) {
      emit(state.copyWith(
        status: ProductsStatus.failure,
        errorMessage: const UnknownFailure().message,
      ));
    }
  }
}
