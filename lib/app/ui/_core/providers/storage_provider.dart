import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/experimental/persist.dart';
import 'package:riverpod_sqflite/riverpod_sqflite.dart';
import 'package:sqflite/sqflite.dart';

final storageProvider = FutureProvider<Storage<String, String>>((ref) async {
  return JsonSqFliteStorage.open(p.join(await getDatabasesPath(), 'riverpod.db'));
});
