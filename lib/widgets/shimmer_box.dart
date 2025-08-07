import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final double height;
  const ShimmerBox({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color baseColor;
    Color highlightColor;

    if (isDark) {
      baseColor = const Color.fromARGB(192, 60, 60, 60);
      highlightColor = const Color.fromARGB(255, 96, 96, 96);
    } else {
      baseColor = const Color.fromARGB(192, 200, 200, 200);
      highlightColor = const Color.fromARGB(255, 240, 240, 240);
    }

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
