import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/Model/Repository/kelas_repository.dart';
import 'package:flutter_app2/Model/Repository/mapel_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var kelasRepositoryProvider =
    Provider<KelasRepository>((ref) => KelasRepository());

// ignore: camel_case_types
class dataLoadedKelasNotifier extends ChangeNotifier {
  bool _status = true;
  List<Kelas> _list = <Kelas>[];
  // ignore: unnecessary_getters_setters
  List<Kelas> get list => _list;
  set list(List<Kelas> newList) {
    _list = newList;
  }

  // ignore: unnecessary_getters_setters
  bool get status => _status;
  set status(bool newStatus) {
    _status = newStatus;
  }

  setListJumlahMapelIncrement(int index) {
    _list[index].jumlahMapel = _list[index].jumlahMapel! + 1;
  }

  setListJumlahMapelDecrement(int index) {
    _list[index].jumlahMapel = _list[index].jumlahMapel! - 1;
  }

  Stream<List<Kelas>> getList() async* {
    yield _list;
  }
}

final dataLoadedKelasProvider = ChangeNotifierProvider<dataLoadedKelasNotifier>(
    (ref) => dataLoadedKelasNotifier());

var mapelRepositoryProvider =
    Provider<MapelRepository>((ref) => MapelRepository());

// ignore: camel_case_types
class dataLoadedMapelInKelasNotifier extends ChangeNotifier {
  List<int> _list = List.filled(6, 0);
  // ignore: unnecessary_getters_setters
  List<int> get list => _list;
  set list(List<int> newList) {
    _list = newList;
  }
}

final dataLoadedMapelInKelasProvider =
    ChangeNotifierProvider<dataLoadedMapelInKelasNotifier>(
        (ref) => dataLoadedMapelInKelasNotifier());
