import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_flutter/features/pagination/presentation/bloc/products_bloc.dart';
import 'package:template_flutter/features/pagination/presentation/bloc/products_events.dart';
import 'package:template_flutter/features/pagination/presentation/bloc/products_state.dart';

class ListFooter extends StatelessWidget {
  final ProductsState state;
  const ListFooter({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    // Still loading next page
    if (state.status == ProductsStatus.loadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Error while loading more (products already visible)
    if (state.status == ProductsStatus.failure) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Column(
            children: [
              const Text('Failed to load more products'),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () =>
                    context.read<ProductsBloc>().add(const ProductsLoadMore()),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // End of list
    if (state.hasReachedMax) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            '✓ All ${state.products.length} products loaded',
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}