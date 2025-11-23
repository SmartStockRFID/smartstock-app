import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/ui/_providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/_providers/current_writing_provider.dart';
import 'package:smart_stock/app/ui/_providers/writing_feedback_ble_listener_provider.dart';
import 'package:smart_stock/app/ui/_shared/app_bar.dart';
import 'package:smart_stock/app/ui/_shared/custom_card.dart';
import 'package:smart_stock/app/ui/_themes/custom_forui.dart';
import 'package:smart_stock/app/ui/labeling/labeling_select_page.dart';

@RoutePage()
class WritingPage extends ConsumerStatefulWidget {
  const WritingPage({required this.targetProductName, required this.mode});

  final String? targetProductName;
  final WritingMode mode;

  @override
  ConsumerState<WritingPage> createState() => _WritingPageState();
}

class _WritingPageState extends ConsumerState<WritingPage> {
  @override
  Widget build(BuildContext context) {
    ref.watch(writingFeedbackBleListenerProvider);

    final writedTags = ref.watch(writingManagerProvider.select((state) => state.writedTags));

    final isResetMode = widget.mode == WritingMode.RESET;

    return Scaffold(
      appBar: baseAppBar(title: 'Gravação'),
      backgroundColor: Colors.white,
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            ref.read(bleConnectionProvider).manager.enterOnReadMode();
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  spacing: 16,
                  children: [
                    CustomCard(
                      title: Text(
                        isResetMode ? 'Modo de restauração' : 'Gravando:',
                        style: context.theme.typography.lg.copyWith(
                          fontWeight: isResetMode ? FontWeight.w700 : FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      child: Center(
                        child: isResetMode
                            ? null
                            : Text(
                                widget.targetProductName ?? '',
                                style: context.theme.typography.xl.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                    CustomCard(
                      title: Text(
                        'Número de etiquetas ${isResetMode ? 'limpas' : 'gravadas'}:',
                        style: context.theme.typography.lg,
                      ),
                      child: Center(
                        child: Text(
                          writedTags.length.toString(),
                          style: context.theme.typography.xl8,
                        ),
                      ),
                    ),
                  ],
                ),
                FButton(
                  onPress: () {
                    context.router.pop();
                  },
                  style: createLargeStyle(
                    context: context,
                    backgroundColor: context.theme.colors.secondary,
                    foregroundColor: context.theme.colors.secondaryForeground,
                  ),
                  child: Text('CONCLUIR', style: context.theme.typography.xl2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
