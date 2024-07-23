class Hari {
  static String tabel = 'HARI';
  static String column1 = 'ID_HARI';
  static String column2 = 'NAMA_HARI';
  final int? idHari;
  final String namaHari;

  Hari({required this.idHari, required this.namaHari});

  factory Hari.fromMap(Map<String, dynamic> map) {
    return Hari(idHari: map[column1], namaHari: map[column2]);
  }
}

class HariRepository {}
