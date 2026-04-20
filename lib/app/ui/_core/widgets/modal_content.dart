import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

class ModalContent extends ConsumerWidget {
  final Widget child;

  const ModalContent({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => FToaster(
    child: Container(
      decoration: BoxDecoration(
        color: context.theme.colors.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border.symmetric(vertical: BorderSide(color: context.theme.colors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8.0),
        child: SafeArea(child: child),
      ),
    ),
  );
}
