import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/domain/firmware/reading_response.dart';
import 'package:smart_stock/app/ui/_core/theme/custom_forui.dart';
import 'package:smart_stock/app/ui/_core/widgets/modal_content.dart';
import 'package:smart_stock/app/ui/shell/widgets/quick_read_current_item_widget.dart';

Future<void> showQuickReadSheet(BuildContext context, ReadingResponseContent readingResponseContent) {
  return showFSheet(
    style: getModalBlurStyle(context).call,
    context: context,
    side: FLayout.btt,
    builder: (context) => ModalContent(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  'Leitura rápida',
                  style: context.theme.typography.xl2.copyWith(fontWeight: FontWeight.bold),
                ),

                const Text(
                  'O conteúdo atual da etiqueta lida é:',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            QuickReadCurrentItem(firstRead: readingResponseContent),
            FButton(
              style: createLargeStyle(
                context: context,
                backgroundColor: Colors.green,
                foregroundColor: Colors.lightGreen,
              ),
              onPress: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'VOLTAR',
                style: context.theme.typography.xl2.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
