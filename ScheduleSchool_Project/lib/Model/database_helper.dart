import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final databaseHelper = Provider((ref) => DatabaseHelper());

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'penjadwalan.db');
    return await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(
            'create table DATA_SEKOLAH ( ID_DATA_SEKOLAH integer not null, NAMA_SEKOLAH char(256) null, NAMA_DESA char(256) null, NAMA_KECAMATAN char(256) null, NAMA_KABUPATEN char(256) null, constraint PK_DATA_SEKOLAH primary key (ID_DATA_SEKOLAH));');
        await db.execute(
            'create table HARI ( ID_HARI integer not null, NAMA_HARI char(256) unique null, constraint PK_HARI primary key (ID_HARI));');
        await db.execute(
            'create table JENIS_KEGIATAN ( ID_JENIS_KEGIATAN integer not null, NAMA_JENIS_KEGIATAN char(256) unique null, constraint PK_JENIS_KEGIATAN primary key (ID_JENIS_KEGIATAN));');
        await db.execute(
            'create table KELAS ( ID_KELAS integer not null, NAMA_KELAS char(256) unique null, constraint PK_KELAS primary key (ID_KELAS));');
        await db.execute(
            'create table KODE_GURU ( ID_KODE_GURU integer not null, KODE_GURU char(256) unique null, STATUS char(256) null, constraint PK_KODE_GURU primary key (ID_KODE_GURU));');
        await db.execute(
            'create table GURU ( ID_GURU integer, ID_KODE_GURU integer null, NAMA_GURU char(256) null, STATUS_KEPALA_SEKOLAH smallint null, constraint PK_GURU primary key (ID_GURU), foreign key (ID_KODE_GURU) references KODE_GURU (ID_KODE_GURU) on update cascade on delete cascade);');
        await db.execute(
            'create table MAPEL ( ID_MAPEL integer, ID_KELAS integer null, NAMA_MAPEL char(256) null, constraint PK_MAPEL primary key (ID_MAPEL), foreign key (ID_KELAS) references KELAS (ID_KELAS) on update cascade on delete cascade);');
        await db.execute(
            '''create table MODEL_JADWAL ( ID_MODEL integer, ID_DATA_SEKOLAH integer null, NAMA_MODEL char(256) unique null, WAKTU_MULAI time null, JUMLAH_JAM_PER_HARI integer null, DURASI_PER_JAM integer null, TAHUN_AJARAN integer null, 
            constraint PK_MODEL_JADWAL primary key (ID_MODEL), foreign key (ID_DATA_SEKOLAH) references DATA_SEKOLAH (ID_DATA_SEKOLAH) on update cascade on delete cascade);''');
        await db.execute(
            '''create table HARI_LIBUR ( ID_HARI_LIBUR integer, ID_MODEL integer null, ID_HARI integer null, STATUS_LIBUR smallint null, constraint PK_HARI_LIBUR primary key (ID_HARI_LIBUR),
            foreign key (ID_MODEL) references MODEL_JADWAL (ID_MODEL) on update cascade on delete cascade, foreign key (ID_HARI) references HARI (ID_HARI) on update cascade on delete cascade);''');
        await db.execute(
            '''create table JADWAL ( ID_JADWAL integer, ID_MODEL integer null, ID_KELAS integer null, ID_GURU integer null, ID_MAPEL integer null, ID_HARI integer null, ID_JENIS_KEGIATAN integer null, JAM_MULAI time null, JAM_SELESAI time null, constraint PK_JADWAL primary key (ID_JADWAL), 
            foreign key (ID_KELAS) references KELAS (ID_KELAS) on update cascade on delete cascade, foreign key (ID_GURU) references GURU (ID_GURU) on update cascade on delete cascade, 
            foreign key (ID_MODEL) references MODEL_JADWAL (ID_MODEL) on update cascade on delete cascade, foreign key (ID_HARI) references HARI (ID_HARI) on update cascade on delete cascade, 
            foreign key (ID_JENIS_KEGIATAN) references JENIS_KEGIATAN (ID_JENIS_KEGIATAN) on update cascade on delete cascade, foreign key (ID_MAPEL) references MAPEL (ID_MAPEL) on update cascade on delete cascade);''');
        await _insertDefaultData(db);
      },
      version: 1,
    );
  }

  Future<void> _insertDefaultData(Database db) async {
    var batch = db.batch();
    List<String> listHari = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    for (int i = 0; i < listHari.length; i++) {
      batch.insert('HARI', {'ID_HARI': i, 'NAMA_HARI': listHari[i]});
    }
    List<String> listJenisKegiatan = [
      'Belajar Mengajar',
      'Istirahat',
      'Pembiasaan Diri',
      'Senam',
      'Sholat Dhuha',
      'Dhuha+Istirahat',
      'Upacara'
    ];
    for (int i = 0; i < listJenisKegiatan.length; i++) {
      batch.insert('JENIS_KEGIATAN', {
        'ID_JENIS_KEGIATAN': i,
        'NAMA_JENIS_KEGIATAN': listJenisKegiatan[i]
      });
    }
    List<String> listKelas = [
      'Kelas 1',
      'Kelas 2',
      'Kelas 3',
      'Kelas 4',
      'Kelas 5',
      'Kelas 6'
    ];
    for (int i = 0; i < listKelas.length; i++) {
      batch.insert('KELAS', {'ID_KELAS': i, 'NAMA_KELAS': listKelas[i]});
    }
    String abjad = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    List<String> dataKodeGuru = abjad.split('');
    for (int i = 0; i < dataKodeGuru.length; i++) {
      batch.insert('KODE_GURU', {
        'ID_KODE_GURU': i,
        'KODE_GURU': dataKodeGuru[i],
        'STATUS': 'Kosong'
      });
    }
    batch.insert('DATA_SEKOLAH', {
      'ID_DATA_SEKOLAH': 0,
      'NAMA_SEKOLAH': 'Madrasah Ibtidaiyah Al-Iman',
      'NAMA_DESA': 'Bader',
      'NAMA_KECAMATAN': 'Jatirogo',
      'NAMA_KABUPATEN': 'Tuban'
    });
    await batch.commit();
  }

  Future<Map> getTotalMapelInAllClass() async {
    final mapelPerKelas = {};
    final List<Map<String, Object?>> result = await _database!.rawQuery('''
    select KELAS.NAMA_KELAS, count(MAPEL.ID_MAPEL) as TOTAL_MAPEL 
    from KELAS
    left join MAPEL ON KELAS.ID_KELAS = MAPEL.ID_KELAS
    group by KELAS.ID_KELAS;
    ''');
    for (final row in result) {
      final namaKelas = row['NAMA_KELAS'] as String;
      final totalMapel = row['TOTAL_MAPEL'] as int;
      mapelPerKelas[namaKelas] = totalMapel;
    }
    return mapelPerKelas;
  }
}
