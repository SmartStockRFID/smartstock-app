import 'package:flutter/material.dart';
import 'package:forui/theme.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

Widget buildInputField({
  required BuildContext context,
  required TextEditingController controller,
  required String labelText,
  required bool obscureText,
  required String? Function(String?) validator,
  bool isCPFField = false,
  TextInputType? keyboardType,
}) {
  return TextFormField(
    keyboardType: keyboardType,
    controller: controller,
    inputFormatters: isCPFField ? [MaskTextInputFormatter(mask: '###.###.###-##')] : [],
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: context.theme.typography.sm.copyWith(
        color: context.theme.colors.secondaryForeground,
        fontWeight: FontWeight.w100,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: context.theme.colors.secondaryForeground, width: 1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: context.theme.colors.secondaryForeground, width: 1),
      ),
    ),
    obscureText: obscureText,
    validator: validator,
  );
}
