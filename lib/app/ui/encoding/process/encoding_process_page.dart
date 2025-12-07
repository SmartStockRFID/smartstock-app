import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smart_stock/app/ui/_core/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/_core/theme/custom_forui.dart';
import 'package:smart_stock/app/ui/_core/widgets/app_bar.dart';
import 'package:smart_stock/app/ui/_core/widgets/custom_card.dart';
import 'package:smart_stock/app/ui/encoding/logic/current_writing_provider.dart';
import 'package:smart_stock/app/ui/encoding/process/logic/writing_feedback_ble_listener_provider.dart';
import 'package:smart_stock/app/ui/encoding/setup/encoding_setup_page.dart';

@RoutePage()
class EncondingProcessPage extends HookConsumerWidget {
  final String? targetProductName;
  final WritingMode mode;

  const EncondingProcessPage({required this.targetProductName, required this.mode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(writingFeedbackBleListenerProvider);

    final isValueChanging = useState(false);

    final writedTags = ref.watch(writingManagerProvider.select((state) => state.writedTags));

    ref.listen(writingManagerProvider.select((state) => state.writedTags), (_, state) async {
      isValueChanging.value = true;
      await Future.delayed(const Duration(milliseconds: 500));
      isValueChanging.value = false;
    });

    final isResetMode = mode == WritingMode.RESET;

    return Scaffold(
      appBar: baseAppBar(title: 'Gravação'),
      backgroundColor: Colors.white,
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            ref
                .read(bleConnectionProvider.select((state) => state.currentState.manager))
                .enterOnReadMode();
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
                                targetProductName ?? '',
                                style: context.theme.typography.xl.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),

                    CustomCard(
                      blink: isValueChanging.value,
                      title: Text(
                        'Número de etiquetas ${isResetMode ? 'limpas' : 'gravadas'}:',
                        style: context.theme.typography.lg,
                      ),
                      child: Center(
                        child: Text(
                          writedTags.length.toString(),
                          style: GoogleFonts.robotoMono(
                            textStyle: context.theme.typography.xl8.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
