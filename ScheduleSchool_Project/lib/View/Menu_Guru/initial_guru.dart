import '../../Model/Repository/kode_guru_repository.dart';

class InitialGuru {
  final String idKodeGuru;
  final String namaGuru;
  final String statusKepalaSekolah;
  final KodeGuru kodeGuru;
  InitialGuru(
      {required this.idKodeGuru,
      required this.namaGuru,
      required this.statusKepalaSekolah,
      required this.kodeGuru});
}
