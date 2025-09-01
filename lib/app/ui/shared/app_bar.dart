import 'package:flutter/material.dart';
import 'package:smart_stock/app/ui/themes/text_styles.dart';

AppBar baseAppBar({required String title}) {
  TextStyle textDecoration = AppTextStyles.titleLarge;
  return AppBar(
    centerTitle: true,
    title: Text(title),
    titleTextStyle: textDecoration,
    backgroundColor: Colors.white,
  );
}
