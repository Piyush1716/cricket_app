import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FakeLoader extends StatelessWidget {
  final double height, width;
  const FakeLoader({this.height = 20, this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[500]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        color: Colors.grey,
      )
    );
  }
}

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
