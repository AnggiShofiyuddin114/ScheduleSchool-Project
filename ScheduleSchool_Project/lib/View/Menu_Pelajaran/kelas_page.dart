import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Provider/provider_menu_pelajaran.dart';
import 'package:flutter_app2/View/Menu_Pelajaran/pelajaran_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../Model/Repository/kelas_repository.dart';

// ignore: must_be_immutable
class KelasPage extends ConsumerWidget {
  KelasPage({Key? key}) : super(key: key);
  late bool pageVisit = false;
  List<Kelas>? dataLoaded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final StreamController<List<Kelas>> streamController = StreamController();
    if (ref.watch(dataLoadedKelasProvider).status == true) {
      pageVisit = true;
      ref.read(dataLoadedKelasProvider.notifier).status = false;
      var dataList =
          ref.watch(kelasRepositoryProvider).getAllKelasCountPelajaran();
      dataList.listen((list) {
        ref.read(dataLoadedKelasProvider.notifier).list = list;
        streamController.sink.add(list);
      });
    }
    if (!pageVisit) {
      var dataList = ref.watch(dataLoadedKelasProvider).getList();
      dataList.listen((list) {
        streamController.sink.add(list);
      });
      pageVisit = true;
    }
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        pageVisit = false;
        ref.read(dataLoadedKelasProvider.notifier).status = true;
        streamController.close();
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Kelas'),
            elevation: 4,
            shadowColor: Colors.black,
            backgroundColor: Colors.lightBlueAccent,
          ),
          body: Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: StreamBuilder(
                  stream: streamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Text("Loading"));
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error'));
                    } else {
                      final dataList = snapshot.data ?? [];
                      return ListView.builder(
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            return _itemCardKelas(
                                context: context,
                                ref: ref,
                                idKelas: dataList[index].idKelas!,
                                namaKelas: dataList[index].namaKelas,
                                jumlahPelajaran: dataList[index].jumlahMapel);
                          });
                    }
                  }))),
    );
  }

  Widget _itemCardKelas(
      {required BuildContext context,
      required WidgetRef ref,
      required idKelas,
      required namaKelas,
      required jumlahPelajaran}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      width: MediaQuery.of(context).size.width - 20,
      height: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
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
              // ignore: sort_child_properties_last
              child: LottieBuilder.asset(
                'assets/lottie4.json',
              ),
              width: 100,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
                border: Border.all(color: Colors.black, width: 2),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 120,
              decoration: const BoxDecoration(
                color: Colors.lightGreen,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  splashColor: Colors.black38,
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PelajaranPage(
                                idKelas: idKelas, namaKelas: namaKelas)));
                    pageVisit = false;
                    // ignore: unused_result
                    ref.refresh(dataLoadedKelasProvider);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(left: 15, top: 2, right: 15),
                        child: Text(
                          namaKelas,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 2),
                        child: Text(
                          'Jumlah Mata Pelajaran = $jumlahPelajaran',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ]),
    );
  }
}
