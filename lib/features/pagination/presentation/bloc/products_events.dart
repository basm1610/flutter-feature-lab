
import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered on first load or pull-to-refresh
class ProductsFetched extends ProductsEvent {
  const ProductsFetched();
}

/// Triggered when the user scrolls near the bottom
class ProductsLoadMore extends ProductsEvent {
  const ProductsLoadMore();
}