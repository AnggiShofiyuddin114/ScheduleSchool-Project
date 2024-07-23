import 'package:flutter_app2/Model/Repository/kode_guru_repository.dart';
import 'package:flutter_app2/Model/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'jadwal_repository.dart';

class Guru {
  static String tabel = 'GURU';
  static String column1 = 'ID_GURU';
  static String column2 = 'ID_KODE_GURU';
  static String column3 = 'NAMA_GURU';
  static String column4 = 'STATUS_KEPALA_SEKOLAH';
  final int? idGuru;
  final int? idKodeGuru;
  final String? namaGuru;
  final String? statusKepalaSekolah;

  Guru(
      {this.idGuru,
      required this.idKodeGuru,
      required this.namaGuru,
      required this.statusKepalaSekolah});

  factory Guru.fromMap(Map<String, dynamic> map) {
    return Guru(
        idGuru: map[column1],
        idKodeGuru: map[column2],
        namaGuru: map[column3],
        statusKepalaSekolah: map[column4]);
  }

  Map<String, dynamic> toMap() {
    return {
      column2: idKodeGuru,
      column3: namaGuru,
      column4: statusKepalaSekolah,
    };
  }
}

class GuruRepository {
  Future<bool> addGuru(Guru guru) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    try {
      await db.insert(Guru.tabel, guru.toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteGuru(int idGuru) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    try {
      var batch = db.batch();
      batch.delete(Guru.tabel,
          where: '${Guru.column1} = ?', whereArgs: [idGuru]);
      batch.update(
          Jadwal.tabel,
          {
            Jadwal.column4: null,
            Jadwal.column5: null,
          },
          where: '${Jadwal.column4} = ?',
          whereArgs: [idGuru]);
      batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<Map<String, Object>>> getAllGuruToKodeGuruStream() async* {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    yield* db
        .rawQuery('''select ${Guru.tabel}.${Guru.column1},
     ${Guru.tabel}.${Guru.column2}, 
     ${Guru.tabel}.${Guru.column3}, 
     ${Guru.tabel}.${Guru.column4}, 
     ${KodeGuru.tabel}.${KodeGuru.column2}, 
     ${KodeGuru.tabel}.${KodeGuru.column3},
     (select count(*) from ${Guru.tabel} where ${Guru.column4} = "True") as STATUS_KEPALA_SEKOLAH_TRUE
      from ${Guru.tabel} join ${KodeGuru.tabel} on ${Guru.tabel}.${Guru.column2} = ${KodeGuru.tabel}.${KodeGuru.column1} 
      order by ${Guru.tabel}.${Guru.column2}''')
        .then((maps) => List.generate(maps.length, (i) {
              return {
                'guru': Guru(
                    idGuru: maps[i][Guru.column1] as int,
                    idKodeGuru: maps[i][Guru.column2] as int,
                    namaGuru: maps[i][Guru.column3] as String,
                    statusKepalaSekolah: maps[i][Guru.column4] as String),
                'kode_guru': KodeGuru(
                    idKodeGuru: maps[i][Guru.column2] as int,
                    kodeGuru: maps[i][KodeGuru.column2] as String,
                    status: maps[i][KodeGuru.column3] as String),
                'status_kepala_sekolah_true':
                    maps[i]['STATUS_KEPALA_SEKOLAH_TRUE'] as int
              };
            }))
        .asStream();
  }

  Future<List<Map<String, Object>>> getAllGuruToKodeGuruFuture(
      int idModel) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    return db.rawQuery('''select ${Guru.tabel}.${Guru.column1},
     ${Guru.tabel}.${Guru.column2}, 
     ${Guru.tabel}.${Guru.column3}, 
     ${Guru.tabel}.${Guru.column4}, 
     ${KodeGuru.tabel}.${KodeGuru.column2}, 
     ${KodeGuru.tabel}.${KodeGuru.column3},
     (select count(*) from ${Guru.tabel} where ${Guru.column4} = "True") as STATUS_KEPALA_SEKOLAH_TRUE
      from ${Guru.tabel}
      left join ${KodeGuru.tabel} on ${Guru.tabel}.${Guru.column2} = ${KodeGuru.tabel}.${KodeGuru.column1}
      group by ${Guru.tabel}.${Guru.column1}, ${Guru.tabel}.${Guru.column2}
      order by ${KodeGuru.tabel}.${KodeGuru.column1}''').then((maps) => List
            .generate(maps.length, (i) {
          return {
            'guru': Guru(
                idGuru: maps[i][Guru.column1] as int,
                idKodeGuru: maps[i][Guru.column2] as int,
                namaGuru: maps[i][Guru.column3] as String,
                statusKepalaSekolah: maps[i][Guru.column4] as String),
            'kode_guru': KodeGuru(
                idKodeGuru: maps[i][Guru.column2] as int,
                kodeGuru: maps[i][KodeGuru.column2] as String,
                status: maps[i][KodeGuru.column3] as String),
            'status_kepala_sekolah_true':
                maps[i]['STATUS_KEPALA_SEKOLAH_TRUE'] as int
          };
        }));
  }

  Future<List<Map<String, Object>>> getAllGuruToKodeGuru(int idModel) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    return db.rawQuery('''select ${Guru.tabel}.${Guru.column1},
     ${Guru.tabel}.${Guru.column2}, 
     ${Guru.tabel}.${Guru.column3}, 
     ${Guru.tabel}.${Guru.column4}, 
     ${KodeGuru.tabel}.${KodeGuru.column2}, 
     ${KodeGuru.tabel}.${KodeGuru.column3},
      count(${Jadwal.tabel}.${Jadwal.column4}) as JUMLAH_GURU,
     (select count(*) from ${Guru.tabel} where ${Guru.column4} = "True") as STATUS_KEPALA_SEKOLAH_TRUE
      from ${Guru.tabel} left join ${Jadwal.tabel} on ${Guru.tabel}.${Guru.column1} = ${Jadwal.tabel}.${Jadwal.column4} and ${Jadwal.tabel}.${Jadwal.column2} = $idModel
      left join ${KodeGuru.tabel} on ${Guru.tabel}.${Guru.column2} = ${KodeGuru.tabel}.${KodeGuru.column1}
      group by ${Guru.tabel}.${Guru.column1}, ${Guru.tabel}.${Guru.column2}
      order by ${KodeGuru.tabel}.${KodeGuru.column1}''').then((maps) => List
            .generate(maps.length, (i) {
          return {
            'guru': Guru(
                idGuru: maps[i][Guru.column1] as int,
                idKodeGuru: maps[i][Guru.column2] as int,
                namaGuru: maps[i][Guru.column3] as String,
                statusKepalaSekolah: maps[i][Guru.column4] as String),
            'kode_guru': KodeGuru(
                idKodeGuru: maps[i][Guru.column2] as int,
                kodeGuru: maps[i][KodeGuru.column2] as String,
                status: maps[i][KodeGuru.column3] as String),
            'jumlah_jam': maps[i]['JUMLAH_GURU'] as int,
            'status_kepala_sekolah_true':
                maps[i]['STATUS_KEPALA_SEKOLAH_TRUE'] as int
          };
        }));
  }

  Future<bool> updateGuru(int idGuru, Guru guru) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    try {
      await db.update(Guru.tabel, guru.toMap(),
          where: '${Guru.column1} = ?',
          whereArgs: [idGuru],
          conflictAlgorithm: ConflictAlgorithm.replace);
      return true;
    } catch (e) {
      return false;
    }
  }
}
