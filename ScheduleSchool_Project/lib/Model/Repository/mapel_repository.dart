import 'dart:async';
import 'package:flutter_app2/Model/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'jadwal_repository.dart';

class Mapel {
  static String tabel = 'MAPEL';
  static String column1 = 'ID_MAPEL';
  static String column2 = 'ID_KELAS';
  static String column3 = 'NAMA_MAPEL';
  final int? idMapel;
  final int? idKelas;
  final String? namaMapel;

  Mapel({this.idMapel, required this.idKelas, required this.namaMapel});

  factory Mapel.fromMap(Map<String, dynamic> map) {
    return Mapel(
        idMapel: map[column1], idKelas: map[column2], namaMapel: map[column3]);
  }

  Map<String, dynamic> toMap() {
    return {
      column2: idKelas,
      column3: namaMapel,
    };
  }
}

class MapelRepository {
  Future<bool> addMapel(Mapel mapel) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    try {
      await db.insert(Mapel.tabel, mapel.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateMapel(int idMapel, Mapel mapel) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    try {
      await db.update(Mapel.tabel, mapel.toMap(),
          where: '${Mapel.column1} = ?', whereArgs: [idMapel]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteMapel(int idMapel) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    try {
      var batch = db.batch();
      batch.delete(Mapel.tabel,
          where: '${Mapel.column1} = ?', whereArgs: [idMapel]);
      batch.update(
          Jadwal.tabel,
          {
            Jadwal.column4: null,
            Jadwal.column5: null,
          },
          where: '${Jadwal.column5} = ?',
          whereArgs: [idMapel]);
      batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<List<Mapel>>> getAllMapel() async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query(Mapel.tabel, orderBy: Mapel.column3);
    return List.generate(6, (i) {
      List<Mapel> data = maps
          .where((element) =>
              (element[Mapel.column2] as int).toString().contains(i.toString()))
          .map((element) => Mapel(
              idMapel: element[Mapel.column1],
              idKelas: element[Mapel.column2],
              namaMapel: element[Mapel.column3]))
          .toList();
      return data;
    });
  }

  Stream<List<Mapel>> getAllMapelInKelas(int idKelas) async* {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    yield* db
        .query(Mapel.tabel,
            where: '${Mapel.column2} = ?',
            whereArgs: [idKelas],
            orderBy: Mapel.column3)
        .then((maps) => List.generate(maps.length, (i) {
              return Mapel(
                  idMapel: maps[i][Mapel.column1] as int,
                  idKelas: maps[i][Mapel.column2] as int,
                  namaMapel: maps[i][Mapel.column3] as String);
            }))
        .asStream();
  }
}
