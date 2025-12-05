import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:smart_stock/app/config/constants.dart';

FBaseButtonStyle Function(FButtonStyle) createDisabledButtonStyle(BuildContext context) {
  return (FButtonStyle baseStyle) {
    final theme = FTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final style = theme.style;

    final disabledBackgroundColor = colors.secondary;
    final disabledForegroundColor = colors.disable(colors.secondaryForeground);

    return FButtonStyle(
      decoration: FWidgetStateMap.all(
        BoxDecoration(color: disabledBackgroundColor, borderRadius: style.borderRadius),
      ),
      focusedOutlineStyle: style.focusedOutlineStyle,
      contentStyle: FButtonContentStyle.inherit(
        typography: typography,
        enabled: disabledForegroundColor,
        disabled: disabledForegroundColor,
      ),
      iconContentStyle: FButtonIconContentStyle.inherit(
        enabled: disabledForegroundColor,
        disabled: disabledForegroundColor,
      ),
      tappableStyle: style.tappableStyle,
    );
  };
}

FBaseButtonStyle Function(FButtonStyle) createLargeStyle({
  required BuildContext context,
  required Color backgroundColor,
  required Color foregroundColor,
}) {
  final theme = FTheme.of(context);
  return (base) {
    final colors = theme.colors;
    final typography = theme.typography;
    final style = theme.style;

    final textStyle = theme.typography.lg.copyWith(
      color: foregroundColor,
      height: 1, // CRUCIAL: Reseta a altura da linha para o texto ficar centralizado no botão
      fontWeight:
          FontWeight.w600, // Opcional: Avenir costuma ficar melhor um pouco mais grossa em botões
    );

    return FButtonStyle(
      decoration: FWidgetStateMap.all(
        BoxDecoration(
          color: backgroundColor, // <-- USA A COR DE FUNDO FORNECIDA
          borderRadius: style.borderRadius,
        ),
      ),
      focusedOutlineStyle: style.focusedOutlineStyle,
      contentStyle:
          FButtonContentStyle.inherit(
            typography: typography,
            enabled: foregroundColor, // <-- USA A COR DE TEXTO FORNECIDA
            disabled: colors.disable(foregroundColor),
          ).copyWith(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: useNewlandTheme ? 18 : 16),
            textStyle: FWidgetStateMap.all(textStyle),
          ),
      iconContentStyle: FButtonIconContentStyle.inherit(
        enabled: foregroundColor, // <-- USA A COR DE TEXTO FORNECIDA
        disabled: colors.disable(foregroundColor),
      ),
      tappableStyle: style.tappableStyle,
    );
  };
}

// Just a shortand
FBaseButtonStyle Function(FButtonStyle) primaryLargeButton(
  BuildContext context, {
  bool disabled = false,
}) {
  return disabled
      ? createLargeStyle(
          context: context,
          backgroundColor: context.theme.colors.disable(context.theme.colors.primary),
          foregroundColor: context.theme.colors.disable(context.theme.colors.primaryForeground),
        )
      : createLargeStyle(
          context: context,
          backgroundColor: context.theme.colors.primary,
          foregroundColor: context.theme.colors.primaryForeground,
        );
}

// Just other shorthand
FBaseButtonStyle Function(FButtonStyle) secondaryLargeButton(BuildContext context) {
  return createLargeStyle(
    context: context,
    backgroundColor: context.theme.colors.secondary,
    foregroundColor: context.theme.colors.secondaryForeground,
  );
}

FModalSheetStyle getModalBlurStyle(BuildContext context) {
  final barrierColor = context.theme.colors.barrier;
  final modalSheetStyle = context.theme.modalSheetStyle;

  final modalStyle = modalSheetStyle.copyWith(
    barrierFilter: (animation) => ImageFilter.compose(
      outer: ImageFilter.blur(sigmaX: animation * 5, sigmaY: animation * 5),
      inner: ColorFilter.mode(barrierColor, BlendMode.srcOver),
    ),
  );

  return modalStyle;
}
