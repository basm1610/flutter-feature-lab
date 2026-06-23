// lib/screens/products_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_flutter/features/pagination/presentation/bloc/products_events.dart';
import 'package:template_flutter/features/pagination/presentation/widgets/error_view.dart';
import 'package:template_flutter/features/pagination/presentation/widgets/list_footer.dart';
import 'package:template_flutter/features/pagination/presentation/widgets/product_card.dart';
import 'package:template_flutter/features/pagination/presentation/widgets/product_card_shimmer.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_state.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  // ─────────────────────────────────────────────────────────────────────────
  // NotificationListener callback
  // Called on every scroll notification; dispatches LoadMore when user is
  // within 200 px of the bottom edge.
  // ─────────────────────────────────────────────────────────────────────────
  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final metrics = notification.metrics;
      final distanceFromBottom = metrics.maxScrollExtent - metrics.pixels;

      if (distanceFromBottom <= 200) {
        context.read<ProductsBloc>().add(const ProductsLoadMore());
      }
    }
    // Return false so the notification keeps bubbling up the tree
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
        actions: [
          // Manual refresh button
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () =>
                context.read<ProductsBloc>().add(const ProductsFetched()),
          ),
        ],
      ),

      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          // ── Initial / Loading ──────────────────────────────────────────
          if (state.status == ProductsStatus.initial ||
              state.status == ProductsStatus.loading) {
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: 8,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, __) => const ProductCardShimmer(),
            );
          }

          // ── Error (no products yet) ────────────────────────────────────
          if (state.status == ProductsStatus.failure &&
              state.products.isEmpty) {
            return ErrorView(
              message: state.errorMessage ?? 'Something went wrong',
              onRetry: () =>
                  context.read<ProductsBloc>().add(const ProductsFetched()),
            );
          }

          // ── Success / LoadingMore ──────────────────────────────────────
          return RefreshIndicator(
            onRefresh: () async {
              context.read<ProductsBloc>().add(const ProductsFetched());
              // Wait until state is no longer loading
              await Future.doWhile(() async {
                await Future.delayed(const Duration(milliseconds: 100));
                // ignore: use_build_context_synchronously
                return context.read<ProductsBloc>().state.status ==
                    ProductsStatus.loading;
              });
            },

            // ── NotificationListener wraps the scrollable ─
            child: NotificationListener<ScrollNotification>(
              onNotification: _onScrollNotification,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.products.length + 1, // +1 for footer
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  // ── Footer is used when reach to all products ──────
                  if (index == state.products.length) {
                    return ListFooter(state: state);
                  }

                  // ── Product card ──────────────────────────────────────
                  return ProductCard(product: state.products[index]);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
