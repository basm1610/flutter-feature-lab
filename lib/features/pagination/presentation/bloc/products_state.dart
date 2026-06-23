// lib/bloc/products_state.dart

import 'package:equatable/equatable.dart';
import 'package:template_flutter/features/pagination/data/models/product_model.dart';

enum ProductsStatus { initial, loading, success, failure, loadingMore }

class ProductsState extends Equatable {
  final ProductsStatus status;
  final List<Product> products;
  final bool hasReachedMax;
  final String? errorMessage;
  final int currentSkip;

  const ProductsState({
    this.status = ProductsStatus.initial,
    this.products = const [],
    this.hasReachedMax = false,
    this.errorMessage,
    this.currentSkip = 0,
  });

  ProductsState copyWith({
    ProductsStatus? status,
    List<Product>? products,
    bool? hasReachedMax,
    String? errorMessage,
    int? currentSkip,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage,
      currentSkip: currentSkip ?? this.currentSkip,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        hasReachedMax,
        errorMessage,
        currentSkip,
      ];
}