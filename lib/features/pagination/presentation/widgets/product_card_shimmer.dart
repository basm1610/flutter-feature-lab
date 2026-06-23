// lib/features/pagination/presentation/widgets/product_card_shimmer.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey.shade300;
    final highlightColor = Colors.grey.shade100;

    Widget shimmerBox({
      required double width,
      required double height,
      double radius = 8,
    }) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    }

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            shimmerBox(
              width: 110,
              height: 110,
              radius: 0,
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerBox(width: 70, height: 20),
                    const SizedBox(height: 8),

                    shimmerBox(width: double.infinity, height: 14),
                    const SizedBox(height: 6),

                    shimmerBox(width: 140, height: 14),
                    const SizedBox(height: 10),

                    shimmerBox(width: 80, height: 12),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        shimmerBox(width: 60, height: 18),
                        shimmerBox(width: 45, height: 18),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}