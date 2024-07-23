import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Model/Repository/data_sekolah_repository.dart';
import 'package:flutter_app2/Model/Repository/kode_guru_repository.dart';
import 'package:flutter_app2/Provider/provider_menu_guru.dart';
import 'package:flutter_app2/Provider/provider_menu_pelajaran.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Model/Repository/guru_repository.dart';
import '../Model/Repository/hari_libur_repository.dart';
import '../Model/Repository/jadwal_repository.dart';
import '../Model/Repository/mapel_repository.dart';

var jadwalRepositoryProvider =
    Provider<JadwalRepository>((ref) => JadwalRepository());
var hariLiburRepositoryProvider =
    Provider<HariLiburRepository>((ref) => HariLiburRepository());
var dataSekolahRepositoryProvider =
    Provider<DataSekolahRepository>((ref) => DataSekolahRepository());

var jadwalRepositoryFutureProvider = FutureProvider.family
    .autoDispose<List<dynamic>, int?>((ref, idModel) async {
  final data1 = await ref.watch(jadwalRepositoryProvider).getAllJadwal(idModel);
  final data2 =
      await ref.watch(hariLiburRepositoryProvider).getAllNotHariLibur(idModel);
  final data3 = await ref.watch(mapelRepositoryProvider).getAllMapel();
  final data4 = await ref
      .watch(guruRepositoryProvider)
      .getAllGuruToKodeGuruFuture(idModel!);
  return [data1, data2, data3, data4];
});

var cetakJadwalFutureProvider =
    FutureProvider.family.autoDispose<List, int>((ref, idModel) async {
  final data1 = await ref.watch(jadwalRepositoryProvider).getAllJadwal(idModel);
  final data2 =
      await ref.watch(hariLiburRepositoryProvider).getAllNotHariLibur(idModel);
  final data3 = await ref
      .watch(guruRepositoryProvider)
      .getAllGuruToKodeGuruFuture(idModel);
  final data4 = await ref.watch(dataSekolahRepositoryProvider).getDataSekolah();
  return [data1, data2, data3, data4];
});

// ignore: camel_case_types
class currentGroupsNotifier extends ChangeNotifier {
  String _currentGroup = '';

  // ignore: unnecessary_getters_setters
  String get currentGroup => _currentGroup;
  set currentGroup(String newValue) {
    _currentGroup = newValue;
  }

  void reset() {
    _currentGroup = '';
  }

  Stream<String> getText() async* {
    yield _currentGroup;
  }
}

final currentGroupsProvider = ChangeNotifierProvider<currentGroupsNotifier>(
    (ref) => currentGroupsNotifier());

var currentGroupsStreamProvider =
    StreamProvider<String>((ref) => ref.watch(currentGroupsProvider).getText());

// ignore: camel_case_types
class selectDataJadwalNotifier extends ChangeNotifier {
  Guru? _guru = Guru(
      idGuru: null,
      idKodeGuru: null,
      namaGuru: null,
      statusKepalaSekolah: null);
  KodeGuru? _kodeGuru =
      KodeGuru(idKodeGuru: null, kodeGuru: null, status: null);
  Mapel? _mapelKelas = Mapel(idMapel: null, idKelas: null, namaMapel: null);
  int _durasiPelajaran = 1;

  // ignore: unnecessary_getters_setters
  Guru? get guru => _guru;
  set guru(Guru? newValue) {
    _guru = newValue;
  }

  // ignore: unnecessary_getters_setters
  KodeGuru? get kodeGuru => _kodeGuru;
  set kodeGuru(KodeGuru? newValue) {
    _kodeGuru = newValue;
  }

  // ignore: unnecessary_getters_setters
  Mapel? get mapelKelas => _mapelKelas;
  set mapelKelas(Mapel? newValue) {
    _mapelKelas = newValue;
  }

  // ignore: unnecessary_getters_setters
  int get durasiPelajaran => _durasiPelajaran;
  set durasiPelajaran(int newValue) {
    _durasiPelajaran = newValue;
  }

  void clear() {
    _guru = Guru(idKodeGuru: null, namaGuru: null, statusKepalaSekolah: null);
    _kodeGuru = KodeGuru(idKodeGuru: null, kodeGuru: null, status: null);
    _mapelKelas = Mapel(idMapel: null, idKelas: null, namaMapel: null);
    _durasiPelajaran = 1;
  }
}

final selectDataJadwalProvider =
    ChangeNotifierProvider<selectDataJadwalNotifier>(
        (ref) => selectDataJadwalNotifier());

final currentSelectDurasiPelajaranProvider =
    ChangeNotifierProvider<selectDataJadwalNotifier>(
        (ref) => selectDataJadwalNotifier());
