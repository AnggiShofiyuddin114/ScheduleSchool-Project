import 'package:flutter/material.dart';
import 'package:flutter_app2/Provider/provider_menu_jadwal_kelas.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Model/Repository/jadwal_repository.dart';
import '../Model/Repository/jenis_kegiatan_repository.dart';
import '../Model/Repository/model_jadwal_repository.dart';

var modelJadwalRepositoryProvider =
    Provider<ModelJadwalRepository>((ref) => ModelJadwalRepository());
var jenisKegiatanRepositoryProvider =
    Provider<JenisKegiatanRepository>((ref) => JenisKegiatanRepository());

// ignore: camel_case_types
class selectDataModelJadwalNotifier extends ChangeNotifier {
  int _idDataSekolah = 0;
  String _waktuMulai = '00:00';
  String _tahunAjaran = '0';
  List<String> _statusHariLibur = List<String>.filled(7, 'FALSE');
  List<String> _selectHariLibur = [];
  // ignore: unnecessary_getters_setters
  int get idDataSekolah => _idDataSekolah;
  set idDataSekolah(int newValue) {
    _idDataSekolah = newValue;
  }

  // ignore: unnecessary_getters_setters
  String get waktuMulai => _waktuMulai;
  set waktuMulai(String newValue) {
    _waktuMulai = newValue;
  }

  // ignore: unnecessary_getters_setters
  String get tahunAjaran => _tahunAjaran;
  set tahunAjaran(String newValue) {
    _tahunAjaran = newValue;
  }

  // ignore: unnecessary_getters_setters
  List<String> get statusHariLibur => _statusHariLibur;
  set statusHariLibur(List<String> newValue) {
    _statusHariLibur = newValue;
  }

  // ignore: unnecessary_getters_setters
  List<String> get selectHariLibur => _selectHariLibur;
  set selectHariLibur(List<String> newValue) {
    _selectHariLibur = newValue;
  }

  setStatusHariLibur(int index, String newValue) {
    _statusHariLibur[index] = newValue;
  }

  setSelectHariLibur(int index, String newValue) {
    _selectHariLibur[index] = newValue;
  }

  addOrRemoveSelectHariLibur(bool isSelected, String newValue) {
    isSelected
        ? _selectHariLibur.remove(newValue)
        : _selectHariLibur.add(newValue);
  }

  void clear() {
    _idDataSekolah = 0;
    _waktuMulai = '';
    _tahunAjaran = '0';
    _statusHariLibur = List<String>.filled(7, 'FALSE');
    _selectHariLibur = [];
  }
}

final selectDataModelJadwalProvider =
    ChangeNotifierProvider<selectDataModelJadwalNotifier>(
        (ref) => selectDataModelJadwalNotifier());

final selectTimeProvider =
    StateProvider((ref) => const TimeOfDay(hour: 0, minute: 0));

var modelJadwalRepositoryFutureProvider = FutureProvider.family
    .autoDispose<Map<String, List<dynamic>>, int?>((ref, idModel) async {
  final value = await ref.watch(jadwalRepositoryProvider).getAllJadwal(idModel);
  var uniqJamMulai =
      value.map((data) => (data['jadwal'] as Jadwal).jamMulai).toSet().toList();
  List allDataPerJam = [];
  for (int i = 0; i < uniqJamMulai.length; i++) {
    List<Map<String, dynamic>> data = value
        .where((element) =>
            (element['jadwal'] as Jadwal).jamMulai.contains(uniqJamMulai[i]))
        .toList();
    var uniqIdJadwal = data
        .map((data) => (data['jadwal'] as Jadwal).idJadwal)
        .toSet()
        .toList()
        .join(',');
    var dataNext = List.generate(uniqJamMulai.length - i - 1, (index) {
      List<Map<String, dynamic>> data2 = value
          .where((element) => (element['jadwal'] as Jadwal)
              .jamMulai
              .contains(uniqJamMulai[index + 1 + i]))
          .toList();
      String allId = data2
          .map((data) => (data['jadwal'] as Jadwal).idJadwal)
          .toSet()
          .toList()
          .join(',');
      var durasi =
          data2.map((data) => (data['durasi'] as int)).toSet().toList()[0];
      return {
        'all_id': allId,
        'durasi': durasi,
      };
    });
    Map<String, dynamic> dataPerJam = Map.from(data[0]);
    dataPerJam['all_id_per_jam'] = uniqIdJadwal;
    dataPerJam['data_next'] = dataNext;
    allDataPerJam.add(dataPerJam);
  }
  List<JenisKegiatan> allJenisKegiatan =
      await ref.watch(jenisKegiatanRepositoryProvider).getAllJenisKegiatan();
  return {
    'all_data_per_jam': allDataPerJam,
    'all_jenis_kegiatan': allJenisKegiatan,
  };
});

// ignore: camel_case_types
class selectEditDataModelJadwalNotifier extends ChangeNotifier {
  JenisKegiatan _selectJenisKegiatan =
      JenisKegiatan(idJenisKegiatan: null, namaJenisKegiatan: '');
  String _durasiJam = '0';
  // ignore: unnecessary_getters_setters
  JenisKegiatan get selectJenisKegiatan => _selectJenisKegiatan;
  set selectJenisKegiatan(JenisKegiatan newValue) {
    _selectJenisKegiatan = newValue;
  }

  // ignore: unnecessary_getters_setters
  String get durasiJam => _durasiJam;
  set durasiJam(String newValue) {
    _durasiJam = newValue;
  }

  void clear() {
    _selectJenisKegiatan =
        JenisKegiatan(idJenisKegiatan: null, namaJenisKegiatan: '');
    _durasiJam = '0';
  }
}

final selectEditDataModelJadwalProvider =
    ChangeNotifierProvider<selectEditDataModelJadwalNotifier>(
        (ref) => selectEditDataModelJadwalNotifier());
