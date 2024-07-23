import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Model/Repository/guru_repository.dart';
import '../Model/Repository/kode_guru_repository.dart';

var kodeGuruRepositoryProvider =
    Provider<KodeGuruRepository>((ref) => KodeGuruRepository());

var guruRepositoryProvider =
    Provider<GuruRepository>((ref) => GuruRepository());

// ignore: camel_case_types
class selectDataGuruNotifier extends ChangeNotifier {
  KodeGuru _selectKodeGuru = KodeGuru(kodeGuru: '', status: '');
  String _statusKepalaSekolah = 'False';

  // ignore: unnecessary_getters_setters
  KodeGuru get selectKodeGuru => _selectKodeGuru;
  set selectKodeGuru(KodeGuru newValue) {
    _selectKodeGuru = newValue;
  }

  // ignore: unnecessary_getters_setters
  String get statusKepalaSekolah => _statusKepalaSekolah;
  set statusKepalaSekolah(String newValue) {
    _statusKepalaSekolah = newValue;
  }
}

final selectDataGuruProvider = ChangeNotifierProvider<selectDataGuruNotifier>(
    (ref) => selectDataGuruNotifier());
