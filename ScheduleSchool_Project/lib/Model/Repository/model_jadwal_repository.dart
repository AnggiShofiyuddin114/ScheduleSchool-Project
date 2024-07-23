import 'package:flutter/material.dart';
import 'package:flutter_app2/Model/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'hari_libur_repository.dart';
import 'hari_repository.dart';
import 'jadwal_repository.dart';

class ModelJadwal {
  static String tabel = 'MODEL_JADWAL';
  static String column1 = 'ID_MODEL';
  static String column2 = 'ID_DATA_SEKOLAH';
  static String column3 = 'NAMA_MODEL';
  static String column4 = 'WAKTU_MULAI';
  static String column5 = 'JUMLAH_JAM_PER_HARI';
  static String column6 = 'DURASI_PER_JAM';
  static String column7 = 'TAHUN_AJARAN';
  final int? idModel;
  final int idDataSekolah;
  final String namaModel;
  final String waktuMulai;
  final int jumlahJamPerhari;
  final int durasiPerjam;
  final int tahunAjaran;
  final List<String>? statusHariLibur;

  ModelJadwal({
    this.idModel,
    required this.idDataSekolah,
    required this.namaModel,
    required this.waktuMulai,
    required this.jumlahJamPerhari,
    required this.durasiPerjam,
    required this.tahunAjaran,
    this.statusHariLibur,
  });

  factory ModelJadwal.fromMap(Map<String, dynamic> map) {
    return ModelJadwal(
      idModel: map[column1],
      idDataSekolah: map[column2],
      namaModel: map[column3],
      waktuMulai: map[column4],
      jumlahJamPerhari: map[column5],
      durasiPerjam: map[column6],
      tahunAjaran: map[column7],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      column2: idDataSekolah,
      column3: namaModel,
      column4: waktuMulai,
      column5: jumlahJamPerhari,
      column6: durasiPerjam,
      column7: tahunAjaran,
    };
  }
}

class ModelJadwalRepository {
  Future<bool> addModelJadwal(ModelJadwal modelJadwal) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    late int id;
    try {
      id = await db.insert(ModelJadwal.tabel, modelJadwal.toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort);
      var batch = db.batch();
      for (int i = 0; i < 7; i++) {
        // hari
        batch.insert(
            HariLibur.tabel,
            HariLibur(
                    idModel: id,
                    idHari: i,
                    statusLibur: modelJadwal.statusHariLibur![i])
                .toMap());
        if (modelJadwal.statusHariLibur![i] == 'FALSE') {
          TimeOfDay waktu = TimeOfDay(
              hour: int.parse(modelJadwal.waktuMulai.split(':')[0]),
              minute: int.parse(modelJadwal.waktuMulai.split(':')[1]));
          for (int j = 0; j < modelJadwal.jumlahJamPerhari; j++) {
            // jumlah jam per hari
            TimeOfDay waktuMulai = waktu;
            DateTime dateTime = DateTime(1, 1, 1, waktu.hour, waktu.minute);
            dateTime =
                dateTime.add(Duration(minutes: modelJadwal.durasiPerjam));
            waktu = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
            for (int k = 0; k < 6; k++) {
              // kelas
              batch.insert(Jadwal.tabel, {
                Jadwal.column2: id,
                Jadwal.column3: k,
                Jadwal.column4: null,
                Jadwal.column5: null,
                Jadwal.column6: i,
                Jadwal.column7: 0,
                Jadwal.column8:
                    '${waktuMulai.hour.toString().padLeft(2, '0')}:${waktuMulai.minute.toString().padLeft(2, '0')}',
                Jadwal.column9:
                    '${waktu.hour.toString().padLeft(2, '0')}:${waktu.minute.toString().padLeft(2, '0')}'
              });
            }
          }
        }
      }
      batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteModelJadwal(int idModel) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    try {
      await db.delete(ModelJadwal.tabel,
          where: '${ModelJadwal.column1} = ?', whereArgs: [idModel]);
      await db.delete(HariLibur.tabel,
          where: '${HariLibur.column2} = ?', whereArgs: [idModel]);
      await db.delete(Jadwal.tabel,
          where: '${Jadwal.column2} = ?', whereArgs: [idModel]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<ModelJadwal>> getAllModelJadwal() async* {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    yield* db.rawQuery('''select ${ModelJadwal.tabel}.${ModelJadwal.column1},
       ${ModelJadwal.tabel}.${ModelJadwal.column2},
       ${ModelJadwal.tabel}.${ModelJadwal.column3},
       ${ModelJadwal.tabel}.${ModelJadwal.column4},
       ${ModelJadwal.tabel}.${ModelJadwal.column5},
       ${ModelJadwal.tabel}.${ModelJadwal.column6},
       ${ModelJadwal.tabel}.${ModelJadwal.column7},
       (select group_concat(${Hari.tabel}.${Hari.column2},', ') 
       from ${HariLibur.tabel} left join ${Hari.tabel} on ${Hari.tabel}.${Hari.column1} = ${HariLibur.tabel}.${HariLibur.column3}
    where ${ModelJadwal.tabel}.${ModelJadwal.column1} = ${HariLibur.tabel}.${HariLibur.column2} and ${HariLibur.tabel}.${HariLibur.column4} = 'TRUE') as hari_libur
    from ${ModelJadwal.tabel} order by ${ModelJadwal.tabel}.${ModelJadwal.column3}
    ''').then((maps) {
      return List.generate(maps.length, (i) {
        return ModelJadwal(
            idModel: maps[i][ModelJadwal.column1] as int?,
            idDataSekolah: maps[i][ModelJadwal.column2] as int,
            namaModel: maps[i][ModelJadwal.column3] as String,
            waktuMulai: maps[i][ModelJadwal.column4] as String,
            jumlahJamPerhari: maps[i][ModelJadwal.column5] as int,
            durasiPerjam: maps[i][ModelJadwal.column6] as int,
            tahunAjaran: maps[i][ModelJadwal.column7] as int,
            statusHariLibur: [maps[i]['hari_libur'] as String]);
      });
    }).asStream();
  }

  Future<bool> updateTahunAjaran(int idModel, int tahunAjaran) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    try {
      await db.update(
          ModelJadwal.tabel,
          {
            ModelJadwal.column7: tahunAjaran,
          },
          where: '${ModelJadwal.column1} = ?',
          whereArgs: [idModel]);
      return true;
    } catch (e) {
      return false;
    }
  }
}
