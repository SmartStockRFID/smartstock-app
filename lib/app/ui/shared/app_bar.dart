import 'package:flutter/material.dart';
import 'package:smart_stock/app/ui/themes/text_styles.dart';

AppBar baseAppBar({String? title, Widget? widgetTitle}) {
  final TextStyle textDecoration = AppTextStyles.titleLarge;
  return AppBar(
    centerTitle: true,
    title: widgetTitle ?? Text(title!),
    titleTextStyle: textDecoration,
    backgroundColor: Colors.white,
  );
}
