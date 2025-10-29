import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/ui/providers/inventory_provider.dart';
import 'package:smart_stock/app/ui/providers/stock_provider.dart';

class ConsoleWidget extends ConsumerStatefulWidget {
  final InventoryManagerState confState;

  const ConsoleWidget({required this.confState});

  @override
  ConsumerState<ConsoleWidget> createState() => _ConsoleWidgetState();
}

class _ConsoleWidgetState extends ConsumerState<ConsoleWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    final typography = context.theme.typography;
    final stockState = ref.watch(stockProvider);

    return Builder(
      builder: (context) {
        if (widget.confState.readings.isEmpty) {
          return FCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _animationController,
                      child: const Icon(Icons.circle, color: Colors.green, size: 12),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'AGUARDANDO LEITURA...',
                      style: typography.sm.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '...',
                  style: typography.xl4.copyWith(
                    color: context.theme.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('OEM: ---'),
                Text(
                  'QUANTIDADE TOTAL',
                  style: typography.lg.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                Text(
                  '--',
                  style: typography.xl5.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }

        return FCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _animationController,
                    child: const Icon(Icons.circle, color: Colors.green, size: 12),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'LENDO...',
                    style: typography.sm.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  stockState.when(
                    data: (parts) {
                      final productIndex = parts.indexWhere(
                        (prod) => prod.productCode == widget.confState.readings.last.productOEM,
                      );
                      return Flexible(
                        child: Text(
                          productIndex != -1 ? parts[productIndex].name : 'Desconhecido',
                          style: typography.xl4.copyWith(
                            color: context.theme.colors.primary,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      );
                    },
                    error: (Object error, StackTrace stackTrace) {
                      return Text(
                        'Desconhecido',
                        style: typography.xl4.copyWith(
                          color: context.theme.colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                    loading: () {
                      return Text(
                        'Procurando...',
                        style: typography.xl4.copyWith(
                          color: context.theme.colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ],
              ),

              Text('OEM: ${widget.confState.readings.last.productOEM}'),
              Text(
                'QUANTIDADE TOTAL',
                style: typography.base.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.confState.readings.last.tagCount.toString(),
                style: typography.xl5.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
