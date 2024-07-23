import 'package:flutter_app2/Model/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class JenisKegiatan {
  static String tabel = 'JENIS_KEGIATAN';
  static String column1 = 'ID_JENIS_KEGIATAN';
  static String column2 = 'NAMA_JENIS_KEGIATAN';
  final int? idJenisKegiatan;
  final String? namaJenisKegiatan;

  JenisKegiatan(
      {required this.idJenisKegiatan, required this.namaJenisKegiatan});

  factory JenisKegiatan.fromMap(Map<String, dynamic> map) {
    return JenisKegiatan(
        idJenisKegiatan: map[column1], namaJenisKegiatan: map[column2]);
  }
}

class JenisKegiatanRepository {
  Future<List<JenisKegiatan>> getAllJenisKegiatan() async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(JenisKegiatan.tabel);
    return List.generate(maps.length, (i) {
      return JenisKegiatan(
          idJenisKegiatan: maps[i][JenisKegiatan.column1],
          namaJenisKegiatan: maps[i][JenisKegiatan.column2]);
    });
  }
}
