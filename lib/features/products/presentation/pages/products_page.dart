import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/utils/responsive.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';
import '../widgets/category_chips_row.dart';
import '../widgets/pagination_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/products_search_bar.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsBloc(
        repository: context.read(),
      )..add(const ProductsStarted()),
      child: const _ProductsView(),
    );
  }
}

class _ProductsView extends StatelessWidget {
  const _ProductsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121216),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.horizontalPadding(context)),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              ProductsSearchBar(
                onChanged: (query) => context
                    .read<ProductsBloc>()
                    .add(ProductsSearchQueryChanged(query)),
              ),
              const SizedBox(height: 16),
              const Text(
                "MEMBER'S EXCLUSIVE SELECTION",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              BlocBuilder<ProductsBloc, ProductsState>(
                buildWhen: (previous, current) =>
                    previous.categories != current.categories ||
                    previous.selectedCategorySlug != current.selectedCategorySlug,
                builder: (context, state) {
                  return CategoryChipsRow(
                    categories: state.categories,
                    selectedSlug: state.selectedCategorySlug,
                    onSelected: (slug) =>
                        context.read<ProductsBloc>().add(ProductsCategorySelected(slug)),
                  );
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<ProductsBloc, ProductsState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case ProductsStatus.initial:
                      case ProductsStatus.loading:
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.amber),
                        );
                      case ProductsStatus.failure:
                        return _ErrorView(
                          message: state.errorMessage ?? 'حصل خطأ غير متوقع',
                          onRetry: () =>
                              context.read<ProductsBloc>().add(const ProductsStarted()),
                        );
                      case ProductsStatus.success:
                        if (state.products.isEmpty) {
                          return const Center(
                            child: Text(
                              'لا توجد نتائج',
                              style: TextStyle(color: Colors.white54),
                            ),
                          );
                        }
                        return MasonryGridView.count(
                          padding: const EdgeInsets.only(bottom: 8),
                          crossAxisCount: Responsive.gridColumns(context),
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          itemCount: state.products.length,
                          itemBuilder: (context, index) =>
                              ProductCard(product: state.products[index]),
                        );
                    }
                  },
                ),
              ),
              BlocBuilder<ProductsBloc, ProductsState>(
                buildWhen: (previous, current) =>
                    previous.currentPage != current.currentPage ||
                    previous.totalPages != current.totalPages ||
                    previous.status != current.status,
                builder: (context, state) {
                  if (state.status != ProductsStatus.success) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: PaginationBar(
                      currentPage: state.currentPage,
                      totalPages: state.totalPages,
                      onPrevious: () =>
                          context.read<ProductsBloc>().add(const ProductsPreviousPageRequested()),
                      onNext: () =>
                          context.read<ProductsBloc>().add(const ProductsNextPageRequested()),
                    ),
                  );
                },
              ),
            ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            child: const Text('حاول مرة ثانية', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
