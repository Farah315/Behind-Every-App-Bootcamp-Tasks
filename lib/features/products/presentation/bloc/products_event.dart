import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

/// Fired once when the page first opens.
class ProductsStarted extends ProductsEvent {
  const ProductsStarted();
}

/// Fired on every keystroke in the search field; the BLoC is the
/// one responsible for debouncing it before calling the API.
class ProductsSearchQueryChanged extends ProductsEvent {
  const ProductsSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Fired when the user taps a category chip. Passing `null`
/// (or the "All" slug) clears the filter.
class ProductsCategorySelected extends ProductsEvent {
  const ProductsCategorySelected(this.categorySlug);

  final String? categorySlug;

  @override
  List<Object?> get props => [categorySlug];
}

class ProductsNextPageRequested extends ProductsEvent {
  const ProductsNextPageRequested();
}

class ProductsPreviousPageRequested extends ProductsEvent {
  const ProductsPreviousPageRequested();
}
