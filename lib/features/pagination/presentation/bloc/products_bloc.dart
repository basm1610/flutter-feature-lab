// lib/bloc/products_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_flutter/features/pagination/data/repositories/product_repository.dart';
import 'package:template_flutter/features/pagination/presentation/bloc/products_events.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepository _repository;

  ProductsBloc({required ProductsRepository repository})
      : _repository = repository,
        super(const ProductsState()) {
    on<ProductsFetched>(_onProductsFetched);
    on<ProductsLoadMore>(_onProductsLoadMore);
  }

  // ─── Initial fetch / refresh ──────────────────────────────────────────────
  Future<void> _onProductsFetched(
    ProductsFetched event,
    Emitter<ProductsState> emit,
  ) async {
    emit(state.copyWith(status: ProductsStatus.loading));

    try {
      final response = await _repository.fetchProducts(skip: 0);

      emit(state.copyWith(
        status: ProductsStatus.success,
        products: response.products,
        hasReachedMax: !response.hasMore,
        currentSkip: response.products.length,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  // ─── Load next page ───────────────────────────────────────────────────────
  Future<void> _onProductsLoadMore(
    ProductsLoadMore event,
    Emitter<ProductsState> emit,
  ) async {
    // Guard: don't fetch if already loading or reached the end
    if (state.hasReachedMax ||
        state.status == ProductsStatus.loadingMore ||
        state.status == ProductsStatus.loading) {
      return;
    }

    emit(state.copyWith(status: ProductsStatus.loadingMore));

    try {
      final response = await _repository.fetchProducts(skip: state.currentSkip);

      final updatedProducts = [...state.products, ...response.products];

      emit(state.copyWith(
        status: ProductsStatus.success,
        products: updatedProducts,
        hasReachedMax: !response.hasMore,
        currentSkip: updatedProducts.length,
      ));
    } catch (e) {
      // Keep existing products visible; just surface the error
      emit(state.copyWith(
        status: ProductsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}