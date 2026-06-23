// lib/repositories/products_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:template_flutter/features/pagination/data/models/product_model.dart';

class ProductsRepository {
  static const String _baseUrl = 'https://dummyjson.com';
  static const int _pageSize = 10;

  final http.Client _client;

  ProductsRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<ProductsResponse> fetchProducts({int skip = 0}) async {
    final uri = Uri.parse(
      '$_baseUrl/products?limit=$_pageSize&skip=$skip',
    );

    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return ProductsResponse.fromJson(json);
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  void dispose() => _client.close();
}