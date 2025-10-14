import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Text title;
  final Widget child;
  final double? sizedBoxHeight;

  const CustomCard({
    super.key,
    required this.title,
    required this.child,
    this.sizedBoxHeight
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            SizedBox(height: sizedBoxHeight ?? 16),
            child,
          ],
        ),
      ),
    );
  }
}