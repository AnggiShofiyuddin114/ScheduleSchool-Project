import 'package:flutter_app2/Model/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class DataSekolah {
  static String tabel = 'DATA_SEKOLAH';
  static String column1 = 'ID_DATA_SEKOLAH';
  static String column2 = 'NAMA_SEKOLAH';
  static String column3 = 'NAMA_DESA';
  static String column4 = 'NAMA_KECAMATAN';
  static String column5 = 'NAMA_KABUPATEN';
  final int? idSekolah;
  final String namaSekolah;
  final String namaDesa;
  final String namaKecamatan;
  final String namaKabupaten;

  DataSekolah(
      {required this.idSekolah,
      required this.namaSekolah,
      required this.namaDesa,
      required this.namaKecamatan,
      required this.namaKabupaten});

  factory DataSekolah.fromMap(Map<String, dynamic> map) {
    return DataSekolah(
        idSekolah: map[column1],
        namaSekolah: map[column2],
        namaDesa: map[column3],
        namaKecamatan: map[column4],
        namaKabupaten: map[column5]);
  }
}

class DataSekolahRepository {
  Future<DataSekolah> getDataSekolah({int id = 0}) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DataSekolah.tabel,
      where: '${DataSekolah.column1} = ?',
      whereArgs: [id],
    );
    return List.generate(maps.length, (i) {
      return DataSekolah(
          idSekolah: maps[i][DataSekolah.column1],
          namaSekolah: maps[i][DataSekolah.column2],
          namaDesa: maps[i][DataSekolah.column3],
          namaKecamatan: maps[i][DataSekolah.column4],
          namaKabupaten: maps[i][DataSekolah.column5]);
    })[0];
  }
}
