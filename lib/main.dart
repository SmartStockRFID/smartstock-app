import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_stock/app/app.dart';
import 'package:smart_stock/app/config/dependencies.dart';

void main() async {
  await dotenv.load();
  setUpGetItInject();
  runApp(ProviderScope(child: App()));
}
