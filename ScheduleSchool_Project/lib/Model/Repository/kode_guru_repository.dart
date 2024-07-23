import 'package:flutter_app2/Model/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class KodeGuru {
  static String tabel = 'KODE_GURU';
  static String column1 = 'ID_KODE_GURU';
  static String column2 = 'KODE_GURU';
  static String column3 = 'STATUS';
  final int? idKodeGuru;
  final String? kodeGuru;
  final String? status;

  KodeGuru({this.idKodeGuru, required this.kodeGuru, required this.status});

  factory KodeGuru.fromMap(Map<String, dynamic> map) {
    return KodeGuru(
        idKodeGuru: map[column1], kodeGuru: map[column2], status: map[column3]);
  }

  Map<String, dynamic> toMap() {
    return {
      column2: kodeGuru,
      column3: status,
    };
  }
}

class KodeGuruRepository {
  Future<List<KodeGuru>> getAllKodeGuruNotActive() async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(KodeGuru.tabel,
        where: '${KodeGuru.column3} = ?', whereArgs: ['Kosong']);
    return List.generate(maps.length, (i) {
      return KodeGuru(
          idKodeGuru: maps[i][KodeGuru.column1],
          kodeGuru: maps[i][KodeGuru.column2],
          status: maps[i][KodeGuru.column3]);
    });
  }

  Future<void> updateStatusKodeGuru(int idKodeGuru, KodeGuru kodeGuru) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    await db.update(KodeGuru.tabel, kodeGuru.toMap(),
        where: '${KodeGuru.column1} = ?',
        whereArgs: [idKodeGuru],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
