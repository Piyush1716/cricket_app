import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FakeProfileImageShimmer extends StatelessWidget {
  const FakeProfileImageShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[500]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300], // Background color
        ),
      ),
    );
  }
}
