import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/ui/providers/ble_connection_provider.dart';
import 'package:smart_stock/app/ui/providers/current_writing_provider.dart';
import 'package:smart_stock/app/ui/providers/writing_feedback_ble_listener_provider.dart';
import 'package:smart_stock/app/ui/shared/app_bar.dart';
import 'package:smart_stock/app/ui/shared/custom_card.dart';
import 'package:smart_stock/app/ui/themes/custom_forui.dart';

@RoutePage()
class WritingPage extends ConsumerStatefulWidget {
  const WritingPage({required this.targetProductName});

  final String targetProductName;

  @override
  ConsumerState<WritingPage> createState() => _WritingPageState();
}

class _WritingPageState extends ConsumerState<WritingPage> {
  @override
  Widget build(BuildContext context) {
    final connectionManager = ref.watch(bleConnectionProvider);

    ref.watch(writingFeedbackBleListenerProvider);

    final writingManager = ref.watch(writingManagerProvider);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          connectionManager.manager.enterOnReadMode(connectionManager.manager.connectedPistol);
        }
      },
      child: Scaffold(
        appBar: baseAppBar(title: 'Gravação'),
        backgroundColor: Colors.white,
        body: SafeArea(
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
                        'Gravando:',
                        style: context.theme.typography.lg,
                        textAlign: TextAlign.center,
                      ),
                      child: Center(
                        child: Text(
                          widget.targetProductName,
                          style: context.theme.typography.xl.copyWith(fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    CustomCard(
                      title: Text(
                        'Número de etiquetas gravadas:',
                        style: context.theme.typography.lg,
                      ),
                      child: Center(
                        child: Text(
                          writingManager.writedTagsCount.toString(),
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
                  child: Text('VOLTAR', style: context.theme.typography.xl2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
