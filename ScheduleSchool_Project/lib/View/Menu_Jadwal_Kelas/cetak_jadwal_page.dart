import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Model/Repository/guru_repository.dart';
import 'package:flutter_app2/Model/Repository/jadwal_repository.dart';
import 'package:flutter_app2/Model/Repository/jenis_kegiatan_repository.dart';
import 'package:flutter_app2/Model/Repository/kelas_repository.dart';
import 'package:flutter_app2/Model/Repository/kode_guru_repository.dart';
import 'package:flutter_app2/Model/Repository/mapel_repository.dart';
import 'package:flutter_app2/Provider/provider_menu_jadwal_kelas.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app2/View/item_quick_alert.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class CetakJadwalPage extends ConsumerWidget {
  final int? idModel;
  final int tahunAjaran;
  const CetakJadwalPage(
      {super.key, required this.idModel, required this.tahunAjaran});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Map>(
        future: CetakJadwal(context, ref, idModel, tahunAjaran),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: Text("Loading")),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                  child: Text(
                snapshot.error.toString(),
                style: const TextStyle(fontSize: 5),
              )),
            );
          } else {
            Map data = snapshot.data!;
            return Scaffold(
                appBar: AppBar(
                  title: const Text('PDF Preview'),
                  backgroundColor: Colors.lightBlue,
                  actions: [
                    IconButton(
                        onPressed: () {
                          saveDocument(
                              context: context,
                              nama: data['name'],
                              pdf: data['pdf']);
                        },
                        icon: const Icon(
                          Icons.save,
                          color: Colors.white,
                        )),
                  ],
                ),
                body: Center(
                    child: PDFView(
                  filePath: data['path'],
                )));
          }
        });
  }

  // ignore: non_constant_identifier_names
  List<List<dynamic>> CekData(List allData, List dataKolom) {
    List<List<dynamic>> result = [];
    int startIdx = dataKolom.indexWhere((element) => element != '');
    int lastIdx = dataKolom.lastIndexWhere((element) => element != '');
    if (startIdx != -1 && lastIdx != -1) {
      for (int i = startIdx; i <= lastIdx; i++) {
        result.add(allData[i]);
      }
    }
    return result;
  }

  // ignore: non_constant_identifier_names
  Future<Map> CetakJadwal(BuildContext context, WidgetRef ref, int? idModel,
      int tahunAjaran) async {
    var data = await ref.watch(cetakJadwalFutureProvider(idModel!).future);
    var dataSekolah = data[3];
    var namaSekolah = dataSekolah.namaSekolah;
    var namaSekolahShort =
        'MI${namaSekolah.substring(namaSekolah.toUpperCase().indexOf('MADRASAH IBTIDAIYAH') + 19)}';
    var uniqJamMulai = await data[0]
        .map((data) => (data['jadwal'] as Jadwal).jamMulai)
        .toSet()
        .toList();
    var dataJam = List.generate(uniqJamMulai.length, (index) {
      var d = data[0].firstWhere(
          (data) => (data['jadwal'] as Jadwal).jamMulai == uniqJamMulai[index]);
      return {
        'no': d['no'],
        'jam_mulai': d['jadwal'].jamMulai,
        'jam_selesai': d['jadwal'].jamSelesai,
        'Jenis_kegiatan': d['jenis_kegiatan']
      };
    });
    String noTertinggi = dataJam
        .map((data) => data['no'])
        .reduce((value, element) => value > element ? value : element)
        .toString();
    var dataGuru = await data[2];
    String ketGuru = await dataGuru.map((data) {
      return '${data['kode_guru'].kodeGuru.padRight(noTertinggi.length + 1, ' ')} ${data['guru'].namaGuru}';
    }).join('\n');
    String ketJam = dataJam.map((data) {
      String textNumber = (data['no'] != 0 ? '${data['no']}.' : '');
      return '${textNumber.padRight(noTertinggi.length + (3 ^ (textNumber.isEmpty ? 0 : 1)), ' ')} ${data['jam_mulai']} - ${data['jam_selesai']} ${data['no'] == 0 ? '(${data['Jenis_kegiatan'].namaJenisKegiatan})' : ''}';
    }).join('\n');
    List header = await data[1]
        .map((data) {
          return data + ';Kd.\nGr.';
        })
        .join(';')
        .split(';');
    header.insert(0, 'No');
    List<List<List<dynamic>>> allData = [];
    for (int i = 0; i < data[1].length; i++) {
      List<List<dynamic>> dataHari = [];
      for (int j = 0; j < uniqJamMulai.length; j++) {
        List<Map<String, dynamic>> data2 = await data[0]
            .where((element) =>
                (element['jadwal'] as Jadwal)
                    .jamMulai
                    .contains(uniqJamMulai[j]) &&
                (element['kelas'] as Kelas)
                    .idKelas
                    .toString()
                    .contains(i.toString()))
            .toList();
        int no = await data2[0]['no'];
        List dataPerHari = data2
            .map((data) {
              var mapel = (data['mapel'] as Mapel).namaMapel == null
                  ? ''
                  : (data['mapel'] as Mapel).namaMapel!;
              var kodeGuru = (data['kode_guru'] as KodeGuru).kodeGuru == null
                  ? ''
                  : (data['kode_guru'] as KodeGuru).kodeGuru!;
              var jenisKegiatan = (data['jenis_kegiatan'] as JenisKegiatan);
              if (jenisKegiatan.idJenisKegiatan! != 0) {
                return '${jenisKegiatan.namaJenisKegiatan!};';
              } else {
                return '$mapel;$kodeGuru';
              }
            })
            .join(';')
            .split(';');
        dataPerHari.insert(0, no != 0 ? no.toString() : '');
        dataHari.add(dataPerHari);
      }
      var filterDataPerHari = dataHari
          .where((element) =>
              element.where((e) => e == '').length != (element.length - 1))
          .toList();
      var dataKolom0 = filterDataPerHari.map((row) => row[0]).toList();
      allData.add(CekData(filterDataPerHari, dataKolom0));
    }
    List<double> w = [15, 56];
    final columWidths = {
      for (int i = 0; i < (data[1].length * 2 + 1); i++)
        i: i != 0
            ? pw.FixedColumnWidth(w[i % 2])
            : pw.FixedColumnWidth(w[i % 2] - 2)
    };
    final columWidths2 = {
      0: const pw.FixedColumnWidth(113),
    };
    final List<String> bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    DateTime now = DateTime.now();
    final table2 = pw.TableHelper.fromTextArray(
      border: const pw.TableBorder(
          top: pw.BorderSide.none,
          bottom: pw.BorderSide.none,
          left: pw.BorderSide.none,
          right: pw.BorderSide.none),
      cellPadding: const pw.EdgeInsets.only(left: 6, top: 2, bottom: 2),
      cellAlignment: pw.Alignment.topLeft,
      data: <List<String>>[
        [''],
        [
          '${' ' * (noTertinggi.length + 3)}KETERANGAN JAM PELAJARAN\n\n$ketJam'
        ],
        ['${' ' * (noTertinggi.length + 3)}KODE GURU :\n\n$ketGuru'],
      ],
      columnWidths: columWidths2,
      cellHeight: 11,
      cellStyle: const pw.TextStyle(fontSize: 6),
    );
    var cellAlignments = {
      0: pw.Alignment.center,
    };
    for (int i = 0; i < data[1].length; i++) {
      cellAlignments[2 * (i + 1)] = pw.Alignment.center;
    }
    List tables = List.generate(6, (index) {
      return pw.TableHelper.fromTextArray(
        border: pw.TableBorder.all(),
        headers: header,
        cellPadding: const pw.EdgeInsets.all(1.5),
        data: allData[index],
        columnWidths: columWidths,
        cellAlignments: cellAlignments,
        headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 6),
        cellStyle: const pw.TextStyle(fontSize: 6),
        headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      );
    });
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
        pageFormat: const PdfPageFormat(
            21.0 * PdfPageFormat.cm, 35.0 * PdfPageFormat.cm),
        margin: const pw.EdgeInsets.all(25),
        build: (pw.Context context) => <pw.Widget>[
              pw.Center(
                child: pw.Paragraph(
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                  text:
                      'JADWAL PELAJARAN ${namaSekolah.toUpperCase()}\nDESA ${dataSekolah.namaDesa.toUpperCase()} KECAMATAN ${dataSekolah.namaKecamatan.toUpperCase()} KABUPATEN ${dataSekolah.namaKabupaten.toUpperCase()}\nTAHUN PELAJARAN $tahunAjaran/${(tahunAjaran + 1).toString()}',
                ),
              ),
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.ListView.builder(
                        itemBuilder: (context, index) {
                          return pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(' Kelas ${index + 1}',
                                    style: const pw.TextStyle(fontSize: 6)),
                                tables[index],
                                pw.SizedBox(height: 7),
                              ]);
                        },
                        itemCount: 6),
                    table2,
                  ]),
              pw.SizedBox(height: 5),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Paragraph(
                          text:
                              '${dataSekolah.namaDesa}, ${now.day} ${bulan[now.month - 1]} ${now.year}\nKepala $namaSekolahShort ${dataSekolah.namaDesa}\n\n'),
                      pw.Text(
                          dataGuru[0]['status_kepala_sekolah_true'] == 1
                              ? dataGuru
                                  .where((element) => (element['guru'] as Guru)
                                      .statusKepalaSekolah!
                                      .toString()
                                      .contains('True'))
                                  .toList()[0]['guru']
                                  .namaGuru
                              : '(..............)',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              decoration: pw.TextDecoration.underline))
                    ]),
                pw.Container(width: 130),
              ]),
            ]));
    final output = await saveDocumentTemp(nama: 'preview.pdf', pdf: pdf);
    return {
      'path': output,
      'context': context,
      'name': 'ScheduleSchool/${idModel}_jadwal_kelas_$tahunAjaran.pdf',
      'pdf': pdf
    };
  }

  Future<String> saveDocumentTemp(
      {required String nama, required pw.Document pdf}) async {
    final bytes = await pdf.save();
    Directory dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$nama');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  Future<bool> saveDocument(
      {required BuildContext context,
      required String nama,
      required pw.Document pdf}) async {
    ItemQuickAlert quickAlertTrue = ItemQuickAlert(
        title: 'Berhasil',
        msg: 'Data berhasil disimpan di',
        type: QuickAlertType.success);
    ItemQuickAlert quickAlertFalse = ItemQuickAlert(
        title: 'Gagal',
        msg: 'Data gagal Disimpan.',
        type: QuickAlertType.error);
    try {
      String? path;
      if (Platform.isAndroid) {
        path = '/storage/emulated/0';
      } else if (Platform.isIOS) {
        path = '/data';
      }
      _showQuickAlert(context, quickAlertTrue.title,
          '${quickAlertTrue.msg}\n$path/$nama', quickAlertTrue.type);
      return true;
    } catch (e) {
      _showQuickAlert(context, quickAlertFalse.title, quickAlertFalse.msg,
          quickAlertFalse.type);
      return false;
    }
  }

  _showQuickAlert(
      BuildContext context, String title, String msg, QuickAlertType type) {
    QuickAlert.show(
      title: title,
      text: msg,
      context: context,
      type: type,
    );
  }
}
