import 'package:flutter_app2/Model/Repository/guru_repository.dart';
import 'package:flutter_app2/Model/Repository/hari_repository.dart';
import 'package:flutter_app2/Model/Repository/jadwal_repository.dart';
import 'package:flutter_app2/Model/Repository/kode_guru_repository.dart';
import 'package:flutter_app2/Model/Repository/mapel_repository.dart';

class InitialDataJadwalPerKelas {
  final Jadwal selectJadwal;
  final Hari hari;
  final int no;
  final Jadwal jadwal;
  final Guru guru;
  final KodeGuru kodeGuru;
  final Mapel mapel;
  final List data3Next;
  final List indexId3Next;

  InitialDataJadwalPerKelas(
      {required this.selectJadwal,
      required this.hari,
      required this.no,
      required this.jadwal,
      required this.guru,
      required this.kodeGuru,
      required this.mapel,
      required this.data3Next,
      required this.indexId3Next});
}
