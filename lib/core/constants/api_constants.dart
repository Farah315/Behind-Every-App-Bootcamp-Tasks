/// Centralized DummyJSON API endpoints & keys used across the app.
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://dummyjson.com';

  static const String products = '$baseUrl/products';
  static const String searchProducts = '$baseUrl/products/search';
  static const String categories = '$baseUrl/products/categories';

  static String productsByCategory(String categorySlug) =>
      '$baseUrl/products/category/$categorySlug';

  // Query param keys
  static const String limitParam = 'limit';
  static const String skipParam = 'skip';
  static const String queryParam = 'q';

  // Pagination defaults
  static const int defaultPageLimit = 10;
}
