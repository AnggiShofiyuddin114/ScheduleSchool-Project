import 'package:flutter/material.dart';
import 'package:flutter_app2/Model/Repository/guru_repository.dart';
import 'package:flutter_app2/Model/Repository/jenis_kegiatan_repository.dart';
import 'package:flutter_app2/Model/Repository/kelas_repository.dart';
import 'package:flutter_app2/Model/Repository/kode_guru_repository.dart';
import 'package:flutter_app2/Model/Repository/mapel_repository.dart';
import 'package:flutter_app2/Model/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'hari_repository.dart';

class Jadwal {
  static String tabel = 'JADWAL';
  static String column1 = 'ID_JADWAL';
  static String column2 = 'ID_MODEL';
  static String column3 = 'ID_KELAS';
  static String column4 = 'ID_GURU';
  static String column5 = 'ID_MAPEL';
  static String column6 = 'ID_HARI';
  static String column7 = 'ID_JENIS_KEGIATAN';
  static String column8 = 'JAM_MULAI';
  static String column9 = 'JAM_SELESAI';
  final int? idJadwal;
  final int idModel;
  final int idKelas;
  int? idGuru;
  int? idMapel;
  final int idHari;
  final int idJenisKegiatan;
  final String jamMulai;
  final String jamSelesai;

  Jadwal(
      {this.idJadwal,
      required this.idModel,
      required this.idKelas,
      required this.idGuru,
      required this.idMapel,
      required this.idHari,
      required this.idJenisKegiatan,
      required this.jamMulai,
      required this.jamSelesai});

  factory Jadwal.fromMap(Map<String, dynamic> map) {
    return Jadwal(
        idJadwal: map[column1],
        idModel: map[column2],
        idKelas: map[column3],
        idGuru: map[column4],
        idMapel: map[column5],
        idHari: map[column6],
        idJenisKegiatan: map[column7],
        jamMulai: map[column8],
        jamSelesai: map[column9]);
  }

  Map<String, dynamic> toMap() {
    return {
      column2: idModel,
      column3: idKelas,
      column4: idGuru,
      column5: idMapel,
      column6: idHari,
      column7: idJenisKegiatan,
      column8: jamMulai,
      column9: jamSelesai,
    };
  }

  set setIdGuru(int? newValue) {
    idGuru = newValue;
  }

  set setIdMapel(int? newValue) {
    idMapel = newValue;
  }
}

class JadwalRepository {
  static Future<void> deleteJadwal(int idModel) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    await db.delete(Jadwal.tabel,
        where: '${Jadwal.column2} = ?', whereArgs: [idModel]);
  }

  Future<bool> updateJadwalGuru(int idGuru) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    try {
      await db.update(
          Jadwal.tabel,
          {
            Jadwal.column4: null,
            Jadwal.column5: null,
          },
          where: '${Jadwal.column4} = ?',
          whereArgs: [idGuru]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, Object>>> getAllJadwal(int? idModel) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    List no = List.generate(6, (index) => List.generate(7, (index) => 0));
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('''select ${Jadwal.tabel}.${Jadwal.column1},
       ${Jadwal.tabel}.${Jadwal.column2},
       ${Jadwal.tabel}.${Jadwal.column3},
       ${Jadwal.tabel}.${Jadwal.column4},
       ${Jadwal.tabel}.${Jadwal.column5},
       ${Jadwal.tabel}.${Jadwal.column6},
       ${Jadwal.tabel}.${Jadwal.column7},
       ${Jadwal.tabel}.${Jadwal.column8},
       ${Jadwal.tabel}.${Jadwal.column9},
       ${Kelas.tabel}.${Kelas.column2},
       ${Guru.tabel}.${Guru.column2},
       ${Guru.tabel}.${Guru.column3},
       ${Guru.tabel}.${Guru.column4},
       ${KodeGuru.tabel}.${KodeGuru.column2},
       ${KodeGuru.tabel}.${KodeGuru.column3},
       ${Mapel.tabel}.${Mapel.column3},
       ${Hari.tabel}.${Hari.column2},
       ${JenisKegiatan.tabel}.${JenisKegiatan.column2},
       ${Kelas.tabel}.${Kelas.column1}
        from ${Jadwal.tabel} left join ${Kelas.tabel} on ${Jadwal.tabel}.${Jadwal.column3} = ${Kelas.tabel}.${Kelas.column1}
        left join ${Guru.tabel} on ${Jadwal.tabel}.${Jadwal.column4} = ${Guru.tabel}.${Guru.column1}
        left join ${KodeGuru.tabel} on ${Guru.tabel}.${Guru.column2} = ${KodeGuru.tabel}.${KodeGuru.column1}
        left join ${Mapel.tabel} on ${Jadwal.tabel}.${Jadwal.column5} = ${Mapel.tabel}.${Mapel.column1}
        left join ${Hari.tabel} on ${Jadwal.tabel}.${Jadwal.column6} = ${Hari.tabel}.${Hari.column1}
        left join ${JenisKegiatan.tabel} on ${Jadwal.tabel}.${Jadwal.column7} = ${JenisKegiatan.tabel}.${JenisKegiatan.column1}
    where ${Jadwal.tabel}.${Jadwal.column2} = $idModel
        order by ${Jadwal.tabel}.${Jadwal.column1}, ${Jadwal.tabel}.${Jadwal.column3}
    ''');
    return List.generate(maps.length, (i) {
      if (maps[i][Jadwal.column7] == 0) {
        no[maps[i][Jadwal.column3]][maps[i][Jadwal.column6]] =
            no[maps[i][Jadwal.column3]][maps[i][Jadwal.column6]] + 1;
      }
      DateTime start =
          DateTime.parse('2024-01-01 ${maps[i][Jadwal.column8]}:00');
      DateTime end = DateTime.parse('2024-01-01 ${maps[i][Jadwal.column9]}:00');
      return {
        'jadwal': Jadwal(
            idJadwal: maps[i][Jadwal.column1],
            idModel: maps[i][Jadwal.column2],
            idKelas: maps[i][Jadwal.column3],
            idGuru: maps[i][Jadwal.column4],
            idMapel: maps[i][Jadwal.column5],
            idHari: maps[i][Jadwal.column6],
            idJenisKegiatan: maps[i][Jadwal.column7],
            jamMulai: maps[i][Jadwal.column8],
            jamSelesai: maps[i][Jadwal.column9]),
        'kelas': Kelas(
            idKelas: maps[i][Jadwal.column3],
            namaKelas: maps[i][Kelas.column2]),
        'guru': Guru(
            idGuru: maps[i][Jadwal.column4],
            idKodeGuru: maps[i][Guru.column2],
            namaGuru: maps[i][Guru.column3],
            statusKepalaSekolah: maps[i][Guru.column4]),
        'kode_guru': KodeGuru(
            idKodeGuru: maps[i][Guru.column2],
            kodeGuru: maps[i][KodeGuru.column2],
            status: maps[i][KodeGuru.column3]),
        'mapel': Mapel(
            idMapel: maps[i][Jadwal.column5],
            idKelas: maps[i][Jadwal.column3],
            namaMapel: maps[i][Mapel.column3]),
        'hari': Hari(
            idHari: maps[i][Jadwal.column6], namaHari: maps[i][Hari.column2]),
        'jenis_kegiatan': JenisKegiatan(
            idJenisKegiatan: maps[i][Jadwal.column7],
            namaJenisKegiatan: maps[i][JenisKegiatan.column2]),
        'id_kelas': maps[i][Jadwal.column3],
        'id_jadwal': maps[i][Jadwal.column1],
        'no': maps[i][Jadwal.column7] != 0
            ? 0
            : no[maps[i][Jadwal.column3]][maps[i][Jadwal.column6]],
        'durasi': end.difference(start).inMinutes,
        'group': '${maps[i][Jadwal.column6]}:${maps[i][Hari.column2]}',
      };
    });
  }

  Future<bool> updateAllJadwal(
      JenisKegiatan selectJenisKegiatan,
      String durasiJam,
      String oldDurasiJam,
      String jamMulai,
      String allId,
      List dataNext) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    try {
      var batch = db.batch();
      TimeOfDay waktu = TimeOfDay(
          hour: int.parse(jamMulai.split(':')[0]),
          minute: int.parse(jamMulai.split(':')[1]));
      DateTime dateTime = DateTime(1, 1, 1, waktu.hour, waktu.minute);
      dateTime = dateTime.add(Duration(minutes: int.parse(durasiJam)));
      waktu = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
      batch.update(
          Jadwal.tabel,
          selectJenisKegiatan.idJenisKegiatan == 0
              ? {
                  Jadwal.column7: selectJenisKegiatan.idJenisKegiatan,
                  Jadwal.column8: jamMulai,
                  Jadwal.column9:
                      '${waktu.hour.toString().padLeft(2, '0')}:${waktu.minute.toString().padLeft(2, '0')}',
                }
              : {
                  Jadwal.column4: null,
                  Jadwal.column5: null,
                  Jadwal.column7: selectJenisKegiatan.idJenisKegiatan,
                  Jadwal.column8: jamMulai,
                  Jadwal.column9:
                      '${waktu.hour.toString().padLeft(2, '0')}:${waktu.minute.toString().padLeft(2, '0')}',
                },
          where: '${Jadwal.column1} in ($allId)');
      if (durasiJam != oldDurasiJam) {
        for (int i = 0; i < dataNext.length; i++) {
          TimeOfDay waktuMulai = waktu;
          DateTime dateTime = DateTime(1, 1, 1, waktu.hour, waktu.minute);
          dateTime = dateTime.add(Duration(minutes: dataNext[i]['durasi']));
          waktu = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
          batch.update(
              Jadwal.tabel,
              {
                Jadwal.column8:
                    '${waktuMulai.hour.toString().padLeft(2, '0')}:${waktuMulai.minute.toString().padLeft(2, '0')}',
                Jadwal.column9:
                    '${waktu.hour.toString().padLeft(2, '0')}:${waktu.minute.toString().padLeft(2, '0')}'
              },
              where: '${Jadwal.column1} in (${dataNext[i]['all_id']})');
        }
      }
      batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<dynamic>> update3Jadwal(
      int idModel,
      Guru selectGuru,
      KodeGuru selectKodeGuru,
      Mapel selectMapelKelas,
      int selectDurasiPelajaran,
      List data3Next,
      List allDataJadwalKelas,
      List indexId3Next,
      {bool statusBentrok = false}) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    try {
      final List<Map<String, dynamic>> dataList = [];
      var batch = db.batch();
      for (int i = 0; i < selectDurasiPelajaran; i++) {
        List data = allDataJadwalKelas
            .where((element) =>
                [data3Next[i]['jadwal'].jamMulai]
                    .contains(element['jadwal'].jamMulai) &&
                [data3Next[i]['group']].contains(element['group']) &&
                [selectGuru.idKodeGuru].contains(element['guru'].idKodeGuru) &&
                data3Next[i]['kelas'].namaKelas != element['kelas'].namaKelas)
            .toList();
        if (data.isEmpty || statusBentrok) {
          batch.update(
              Jadwal.tabel,
              {
                Jadwal.column4: selectGuru.idGuru,
                Jadwal.column5: selectMapelKelas.idMapel
              },
              where: '${Jadwal.column1} = ?',
              whereArgs: [data3Next[i]['jadwal'].idJadwal]);
          dataList.add({
            'text': 'Jam ke ${data3Next[i]['no']} berhasil ditambah',
            'status': 'berhasil',
          });
          allDataJadwalKelas[indexId3Next[i]]['jadwal'].setIdGuru =
              selectGuru.idGuru;
          allDataJadwalKelas[indexId3Next[i]]['jadwal'].setIdMapel =
              selectMapelKelas.idMapel;
          allDataJadwalKelas[indexId3Next[i]]['guru'] = selectGuru;
          allDataJadwalKelas[indexId3Next[i]]['kode_guru'] = selectKodeGuru;
          allDataJadwalKelas[indexId3Next[i]]['mapel'] = selectMapelKelas;
        } else {
          dataList.add({
            'text':
                'Jam ke ${data3Next[i]['no']} bentrok (${(data[0]['hari'] as Hari).namaHari} ${(data[0]['kelas'] as Kelas).namaKelas})',
            'status': 'gagal',
            'data3Next': data3Next[i],
            'indexId3Next': indexId3Next[i],
          });
        }
      }
      batch.commit();
      final allDataGuru =
          await GuruRepository().getAllGuruToKodeGuruFuture(idModel);
      return [true, dataList, allDataJadwalKelas, allDataGuru];
    } catch (e) {
      return [false, [], allDataJadwalKelas];
    }
  }
}
