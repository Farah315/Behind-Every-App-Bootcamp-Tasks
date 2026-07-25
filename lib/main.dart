import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/network/dio_client.dart';
import 'features/products/data/datasources/product_remote_data_source.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/presentation/pages/products_page.dart';

void main() {
  runApp(const ProductsApp());
}

class ProductsApp extends StatelessWidget {
  const ProductsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Manual, constructor-based dependency injection — no service
    // locator package needed for a single-feature app. Swapping the
    // data source (e.g. for tests) only means changing this wiring.
    final dioClient = DioClient();
    final remoteDataSource = ProductRemoteDataSourceImpl(client: dioClient);
    final repository = ProductRepositoryImpl(remoteDataSource: remoteDataSource);

    return RepositoryProvider<ProductRepository>.value(
      value: repository,
      child: MaterialApp(
        title: 'Products Page',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF121216),
          colorScheme: const ColorScheme.dark(primary: Colors.amber),
        ),
        home: const ProductsPage(),
      ),
    );
  }
}
