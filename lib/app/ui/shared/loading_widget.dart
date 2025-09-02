import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final Color color;
  final double strokeWidth;

  const LoadingWidget({
    super.key,
    this.color = Colors.black,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
