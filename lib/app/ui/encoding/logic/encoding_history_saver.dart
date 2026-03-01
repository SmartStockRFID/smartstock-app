import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:smart_stock/app/utils/logger.dart';
import 'package:sqflite/sqflite.dart';

const CREATE_HISTORY_TABLE =
    'CREATE TABLE $TABLE_NAME(id INTEGER PRIMARY KEY NOT NULL, productCode VARCHAR(20) NULL, quantity INTEGER NOT NULL, lastEncodingAt TIMESTAMP NOT NULL)'; // I dont know if i can use timestamp for lastENcondignAt

const DATABASE_NAME = 'SSRFID_MANUAL_DATABASE';
const TABLE_NAME = 'ENCODINGS_HISTORY';

Future<List<EncodingRecord>> getEncodingHistory() async {
  final Database db = await _getDatabase();

  final query = await db.query(TABLE_NAME, orderBy: 'id DESC');

  final list = query.map(EncodingRecord.fromMap).toList();

  return list;
}

Future<void> updateOrInsertRegister({required String? productCode}) async {
  final Database db = await _getDatabase();
  logger.i('Entrei no updateOrInsertRegister com productCode $productCode');
  final result = await db.query(TABLE_NAME, limit: 1, orderBy: 'id DESC');

  if (result.isEmpty || EncodingRecord.fromMap(result.first).productCode != productCode) {
    logger.i(
      'Inserir novo vei, pq productCode ${result.isEmpty ? 'null' : result.first['productCode']}',
    );
    final newRegister = EncodingRecord(
      id: -1,
      productCode: productCode,
      quantity: 1,
      lastEncodingAt: DateTime.now(),
    );
    await db.insert(TABLE_NAME, newRegister.toMap());
  } else {
    logger.i('Vou atualizar mana, por causa do ${result.first['productCode']}');

    final asRecord = EncodingRecord.fromMap(result.first);
    db.update(TABLE_NAME, {
      ...asRecord.toMap(),
      'quantity': asRecord.quantity + 1,
    }, where: 'id = ${asRecord.id}');
  }
}

Future<Database> _getDatabase() async {
  return openDatabase(
    join(await getDatabasesPath(), DATABASE_NAME),
    onCreate: (db, version) => db.execute(CREATE_HISTORY_TABLE),
    version: 1,
  );
}

@immutable
class EncodingRecord {
  final int id;
  final String? productCode; // Se não tem productCode, assumo que é um Reset
  final int quantity;
  final DateTime lastEncodingAt;

  const EncodingRecord({
    required this.id,
    required this.productCode,
    required this.quantity,
    required this.lastEncodingAt,
  });

  factory EncodingRecord.fromMap(Map<String, dynamic> map) => EncodingRecord(
    id: map['id'] as int,
    productCode: map['productCode'] as String?,
    quantity: map['quantity'] as int,
    lastEncodingAt: DateTime.parse(map['lastEncodingAt'] as String),
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productCode': productCode,
      'quantity': quantity,
      'lastEncodingAt': lastEncodingAt.toIso8601String(),
    };
  }
}
