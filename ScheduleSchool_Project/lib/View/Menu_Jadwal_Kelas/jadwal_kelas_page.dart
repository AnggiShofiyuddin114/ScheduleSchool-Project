import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Model/Repository/model_jadwal_repository.dart';
import 'package:flutter_app2/View/Menu_Jadwal_Kelas/cetak_jadwal_page.dart';
import 'package:flutter_app2/View/Menu_Jadwal_Kelas/jumlah_jam_guru.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../Provider/provider_menu_model_jadwal.dart';
import '../Menu_Jadwal_Kelas/atur_jadwal_per_kelas_page.dart';

// ignore: must_be_immutable
class JadwalKelasPage extends ConsumerWidget {
  JadwalKelasPage({Key? key}) : super(key: key);
  late BuildContext context;
  late bool pageVisit = false;
  late StreamController<List<ModelJadwal>> _streamController =
      StreamController();

  TextEditingController textNamaModel = TextEditingController();
  TextEditingController textJumlahJamPerHari = TextEditingController();
  TextEditingController textDurasiPerHari = TextEditingController();
  TextEditingController textTahunAjaran = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    this.context = context;
    if (!pageVisit) {
      _streamController = StreamController();
      _updateController(ref);
      pageVisit = true;
    }
    // ignore: deprecated_member_use
    return WillPopScope(
        onWillPop: () async {
          pageVisit = false;
          _streamController.close();
          Navigator.of(context).pop();
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('Jadwal Kelas'),
            elevation: 4,
            shadowColor: Colors.black,
            backgroundColor: Colors.lightBlueAccent,
          ),
          body: StreamBuilder<List<ModelJadwal>>(
              stream: _streamController.stream,
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text("Loading"));
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error'));
                } else {
                  final dataList = snapshot.data ?? [];
                  return dataList.isEmpty
                      ? const Center(
                          child: Text('Kosong'),
                        )
                      : _listModelJadwal(ref, dataList);
                }
              }),
        ));
  }

  Widget _listModelJadwal(WidgetRef ref, List<ModelJadwal> data) {
    return ListView.builder(
        padding: const EdgeInsets.only(bottom: 5, top: 5),
        itemCount: data.length,
        itemBuilder: (_, index) {
          return Slidable(
              key: ValueKey(index),
              endActionPane: ActionPane(
                motion: const BehindMotion(),
                children: [
                  SlidableAction(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.blue,
                    icon: Icons.edit,
                    label: 'Atur Model',
                    onPressed: (context) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AturJadwalPerkelasPage(
                              idModel: data[index].idModel,
                              namaModel: data[index].namaModel,
                              jumlahJamPerhari: data[index].jumlahJamPerhari,
                            ),
                          ));
                    },
                  ),
                  SlidableAction(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    backgroundColor: Colors.lightGreen,
                    foregroundColor: Colors.blue,
                    icon: Icons.print,
                    label: 'Cetak',
                    onPressed: (context) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CetakJadwalPage(
                                idModel: data[index].idModel,
                                tahunAjaran: data[index].tahunAjaran),
                          ));
                    },
                  ),
                ],
              ),
              child: _itemCardModelJadwal(ref, data[index]));
        });
  }

  void _updateController(WidgetRef ref) {
    var dataList = ref.watch(modelJadwalRepositoryProvider).getAllModelJadwal();
    dataList.listen((list) {
      _streamController.sink.add(list);
    });
  }

  Widget _itemCardModelJadwal(
    WidgetRef ref,
    ModelJadwal modelJadwal,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      width: MediaQuery.of(context).size.width - 20,
      height: 127,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.lightGreen,
          boxShadow: const [
            BoxShadow(
                color: Colors.black54,
                blurRadius: 5,
                spreadRadius: 2,
                offset: Offset(0, 4)),
          ]),
      child: Stack(children: <Widget>[
        Row(
          children: [
            Container(
              width: 80,
              height: 127,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Image.asset('images/Icon_schedule11.png'),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 100,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                color: Colors.lightGreen,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  splashColor: Colors.black38,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JumlahJamGuru(
                                  idModel: modelJadwal.idModel,
                                  namaModel: modelJadwal.namaModel,
                                )));
                    pageVisit = false;
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(left: 15, top: 5, right: 15),
                        width: MediaQuery.of(context).size.width - 120,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          modelJadwal.namaModel,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        width: MediaQuery.of(context).size.width - 120,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Waktu Mulai = ${modelJadwal.waktuMulai}',
                          style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        width: MediaQuery.of(context).size.width - 120,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Jumlah Jam per Hari = ${modelJadwal.jumlahJamPerhari}',
                          style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        width: MediaQuery.of(context).size.width - 120,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Durasi per Jam = ${modelJadwal.durasiPerjam} Menit',
                          style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        width: MediaQuery.of(context).size.width - 120,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Tahun Ajaran = ${modelJadwal.tahunAjaran}',
                          style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 5),
                        width: MediaQuery.of(context).size.width - 120,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hari libur = ${modelJadwal.statusHariLibur![0]}',
                          style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
