import 'package:flutter/material.dart';
import 'package:smart_stock/app/ui/_themes/text_styles.dart';

AppBar baseAppBar({
  String? title,
  Widget? widgetTitle,
  Widget? leadingButton,
  List<Widget>? actions,
}) {
  final TextStyle textDecoration = AppTextStyles.titleLarge.copyWith(color: Colors.white);
  return AppBar(
    centerTitle: true,
    actions: actions,
    leading: leadingButton,
    title: widgetTitle ?? Text(title!),
    titleTextStyle: textDecoration,
    backgroundColor: Colors.black,
    iconTheme: const IconThemeData(color: Colors.white),
  );
}
