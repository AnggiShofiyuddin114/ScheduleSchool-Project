import 'package:flutter_app2/Model/Repository/mapel_repository.dart';
import 'package:flutter_app2/Model/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class Kelas {
  static String tabel = 'KELAS';
  static String column1 = 'ID_KELAS';
  static String column2 = 'NAMA_KELAS';
  final int? idKelas;
  final String namaKelas;
  late int? jumlahMapel;

  Kelas({required this.idKelas, required this.namaKelas, this.jumlahMapel});

  factory Kelas.fromMap(Map<String, dynamic> map) {
    return Kelas(idKelas: map[column1], namaKelas: map[column2]);
  }
}

class KelasRepository {
  Stream<List<Kelas>> getAllKelasCountPelajaran() async* {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final Database db = await databaseHelper.database;
    yield* db
        .rawQuery('''select ${Kelas.tabel}.${Kelas.column1},
     ${Kelas.tabel}.${Kelas.column2}, count(${Mapel.tabel}.${Mapel.column2}) as JUMLAH_PELAJARAN
      from ${Kelas.tabel} left join ${Mapel.tabel} on ${Kelas.tabel}.${Kelas.column1} = ${Mapel.tabel}.${Mapel.column2}
      group by ${Kelas.tabel}.${Kelas.column1}, ${Kelas.tabel}.${Kelas.column2}''')
        .then((maps) => List.generate(maps.length, (i) {
              return Kelas(
                  idKelas: maps[i][Kelas.column1] as int,
                  namaKelas: maps[i][Kelas.column2] as String,
                  jumlahMapel: maps[i]['JUMLAH_PELAJARAN'] as int);
            }))
        .asStream();
  }
}
