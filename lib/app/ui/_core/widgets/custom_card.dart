import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget? title;
  final Widget child;
  final double? sizedBoxHeight;
  final bool? blink;

  const CustomCard({super.key, this.title, required this.child, this.sizedBoxHeight, this.blink});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          foregroundDecoration: (blink ?? false)
              ? BoxDecoration(
                  border: Border.all(color: Colors.green, width: 8),

                  borderRadius: BorderRadius.circular(12),
                )
              : null,
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
                if (title != null) ...[
                  title!,
                  SizedBox(height: sizedBoxHeight ?? 16),
                ] else
                  const Center(),
                child,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
