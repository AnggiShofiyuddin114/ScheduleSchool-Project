class InitialModelJadwal {
  final String namaModel;
  final String waktuMulai;
  final String jumlahJamPerhari;
  final String durasiPerjam;
  final String tahunAjaran;
  final List<String> statusHariLibur;

  InitialModelJadwal(
      {required this.namaModel,
      required this.waktuMulai,
      required this.jumlahJamPerhari,
      required this.durasiPerjam,
      required this.tahunAjaran,
      required this.statusHariLibur});
}
