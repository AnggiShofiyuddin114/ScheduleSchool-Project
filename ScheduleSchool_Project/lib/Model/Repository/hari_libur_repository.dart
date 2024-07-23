import 'package:flutter_app2/Model/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'hari_repository.dart';

class HariLibur {
  static String tabel = 'HARI_LIBUR';
  static String column1 = 'ID_HARI_LIBUR';
  static String column2 = 'ID_MODEL';
  static String column3 = 'ID_HARI';
  static String column4 = 'STATUS_LIBUR';
  final int? idHariLibur;
  final int idModel;
  final int idHari;
  final String? statusLibur;

  HariLibur(
      {this.idHariLibur,
      required this.idModel,
      required this.idHari,
      required this.statusLibur});

  factory HariLibur.fromMap(Map<String, dynamic> map) {
    return HariLibur(
        idHariLibur: map[column1],
        idModel: map[column2],
        idHari: map[column3],
        statusLibur: map[column4]);
  }

  Map<String, dynamic> toMap() {
    return {
      column2: idModel,
      column3: idHari,
      column4: statusLibur,
    };
  }
}

class HariLiburRepository {
  static Future<bool> deleteHariLibur(int idModel) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    try {
      await db.delete(HariLibur.tabel,
          where: '${HariLibur.column2} = ?', whereArgs: [idModel]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<String>> getAllNotHariLibur(int? idModel) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    select ${Hari.tabel}.${Hari.column2} from ${HariLibur.tabel} join ${Hari.tabel}
     on ${HariLibur.tabel}.${HariLibur.column3} = ${Hari.tabel}.${Hari.column1}
      where ${HariLibur.tabel}.${HariLibur.column4} = 'FALSE' and ${HariLibur.tabel}.${HariLibur.column2} = $idModel
    ''');
    return List.generate(maps.length, (i) => maps[i][Hari.column2]);
  }
}
