import 'package:flutter/material.dart';
import 'package:flutter_app2/Model/Repository/kode_guru_repository.dart';
import 'package:flutter_app2/color_code_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Model/Repository/guru_repository.dart';
import '../../Provider/provider_menu_guru.dart';

// ignore: must_be_immutable
class JumlahJamGuru extends ConsumerWidget {
  final int? idModel;
  final String? namaModel;
  JumlahJamGuru({Key? key, this.idModel, this.namaModel}) : super(key: key);
  late BuildContext context;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    this.context = context;
    var dataGuru =
        ref.watch(guruRepositoryProvider).getAllGuruToKodeGuru(idModel!);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Guru ($namaModel)'),
        elevation: 4,
        shadowColor: Colors.black,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: FutureBuilder<List<Map<String, Object>>>(
          future: dataGuru,
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
                  : _listGuru(ref, dataList);
            }
          }),
    );
  }

  Widget _listGuru(WidgetRef ref, List<Map<String, Object>> data) {
    return ListView.builder(
        padding: const EdgeInsets.only(bottom: 5, top: 5),
        itemCount: data.length,
        itemBuilder: (_, index) {
          return _itemCardGuru(
              ref,
              (data[index]['guru'] as Guru).idGuru,
              (data[index]['guru'] as Guru),
              (data[index]['jumlah_jam'] as int),
              (data[index]['kode_guru'] as KodeGuru));
        });
  }

  Widget _itemCardGuru(
    WidgetRef ref,
    int? idGuru,
    Guru guru,
    int jumlahJam,
    KodeGuru kodeGuru,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      width: MediaQuery.of(context).size.width - 20,
      height: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
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
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15)),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: const Icon(
                    Icons.account_circle,
                    color: Colors.black,
                    size: 70,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: (guru.statusKepalaSekolah == 'True')
                      ? Container(
                          margin: const EdgeInsets.all(2),
                          child: const Icon(
                            Icons.star,
                            size: 20,
                            color: Colors.yellow,
                          ))
                      : Container(),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
              width: MediaQuery.of(context).size.width - 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                color: colorCodeMap[kodeGuru.kodeGuru],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 120,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      guru.namaGuru!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 11.5,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 120,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Kode Guru = ${kodeGuru.kodeGuru}',
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 120,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Jumlah Jam = $jumlahJam',
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
