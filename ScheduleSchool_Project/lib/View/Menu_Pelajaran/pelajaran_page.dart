import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Model/Repository/mapel_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quickalert/quickalert.dart';
import '../../Provider/provider_menu_pelajaran.dart';
import '../item_quick_alert.dart';

// ignore: must_be_immutable
class PelajaranPage extends ConsumerWidget {
  final int idKelas;
  final String namaKelas;
  late bool pageVisit = false;
  final StreamController<List<Mapel>> _streamController = StreamController();
  TextEditingController textNamaPelajaran = TextEditingController();
  late String _inputNamaPelajaran = '';
  late bool _inputAktif = false;
  late BuildContext context;
  final _formKey = GlobalKey<FormState>();
  late List<Mapel> dataMapel;

  PelajaranPage({Key? key, required this.idKelas, required this.namaKelas})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    this.context = context;
    if (ref.watch(dataLoadedMapelInKelasProvider).list[idKelas] == 0) {
      pageVisit = true;
      ref.read(dataLoadedMapelInKelasProvider.notifier).list =
          List.generate(6, (index) => index == idKelas ? 1 : 0);
      _updateController(ref);
    }
    if (!pageVisit) {
      _updateController(ref);
      pageVisit = true;
    }
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Mata Pelajaran $namaKelas'),
          elevation: 4,
          shadowColor: Colors.black,
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Stack(children: <Widget>[
          StreamBuilder<List<Mapel>>(
              stream: _streamController.stream,
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text("Loading"));
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error'));
                } else {
                  dataMapel = snapshot.data ?? [];
                  return dataMapel.isEmpty
                      ? const Center(
                          child: Text('Kosong'),
                        )
                      : _listPelajaran(ref, dataMapel);
                }
              }),
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add),
                  onPressed: () {
                    _inputAktif = false;
                    ItemQuickAlert quickAlertTrue = ItemQuickAlert(
                        title: 'Berhasil',
                        msg: 'Data berhasil dimasukan.',
                        type: QuickAlertType.success);
                    ItemQuickAlert quickAlertFalse = ItemQuickAlert(
                        title: 'Gagal',
                        msg: 'Data sudah ada.',
                        type: QuickAlertType.error);
                    _showModalBottomSheet(
                        ref: ref,
                        textTitle: 'Tambah Mata Pelajaran',
                        textButton: 'Simpan',
                        initialText: '',
                        onPress: (mapel) {
                          if (dataMapel
                              .where((element) =>
                                  element.namaMapel == mapel.namaMapel)
                              .toList()
                              .isNotEmpty) {
                            _showQuickAlert(quickAlertFalse.title,
                                quickAlertFalse.msg, quickAlertFalse.type);
                          } else {
                            ref
                                .read(mapelRepositoryProvider)
                                .addMapel(mapel)
                                .then((value) {
                              if (value) {
                                ref
                                    .read(dataLoadedKelasProvider.notifier)
                                    .setListJumlahMapelIncrement(idKelas);
                                _showQuickAlert(quickAlertTrue.title,
                                    quickAlertTrue.msg, quickAlertTrue.type);
                              } else {
                                _showQuickAlert(quickAlertFalse.title,
                                    quickAlertFalse.msg, quickAlertFalse.type);
                              }
                            });
                          }
                        });
                  },
                ),
              )),
        ]));
  }

  void _updateController(WidgetRef ref) {
    var dataList =
        ref.watch(mapelRepositoryProvider).getAllMapelInKelas(idKelas);
    dataList.listen((list) {
      _streamController.sink.add(list);
    });
  }

  Widget _listPelajaran(WidgetRef ref, List<Mapel> data) {
    return ListView.builder(
        padding: const EdgeInsets.only(bottom: 85, top: 5),
        itemCount: data.length,
        itemBuilder: (_, index) {
          return Slidable(
              key: ValueKey(index),
              endActionPane: ActionPane(
                motion: const BehindMotion(),
                children: [
                  SlidableAction(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.blue,
                    icon: Icons.edit,
                    label: 'Edit',
                    onPressed: (context) {
                      editAction(
                          ref, data[index].idMapel!, data[index].namaMapel!);
                    },
                  ),
                  SlidableAction(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.blue,
                    icon: Icons.delete,
                    label: 'Delete',
                    onPressed: (context) {
                      deleteAction(
                          ref, data[index].idMapel!, data[index].namaMapel!);
                    },
                  ),
                ],
              ),
              child: _itemCardPelajaran(ref, data[index].namaMapel!));
        });
  }

  void editAction(WidgetRef ref, int idPelajaran, String namaPelajaran) {
    _inputAktif = false;
    ItemQuickAlert quickAlertTrue = ItemQuickAlert(
        title: 'Berhasil',
        msg: 'Data berhasil diperbarui.',
        type: QuickAlertType.success);
    ItemQuickAlert quickAlertFalse = ItemQuickAlert(
        title: 'Gagal', msg: 'Data sudah ada.', type: QuickAlertType.error);
    _showModalBottomSheet(
      ref: ref,
      textTitle: 'Edit Mata Pelajaran',
      textButton: 'Ubah',
      initialText: namaPelajaran,
      onPress: (mapel) {
        if (dataMapel
                .where((element) => element.namaMapel == mapel.namaMapel)
                .toList()
                .isNotEmpty &&
            mapel.namaMapel != namaPelajaran) {
          _showQuickAlert(
              quickAlertFalse.title, quickAlertFalse.msg, quickAlertFalse.type);
        } else if (mapel.namaMapel != namaPelajaran) {
          ref
              .read(mapelRepositoryProvider)
              .updateMapel(idPelajaran, mapel)
              .then((value) {
            if (value) {
              _showQuickAlert(quickAlertTrue.title, quickAlertTrue.msg,
                  quickAlertTrue.type);
            } else {
              _showQuickAlert(quickAlertFalse.title, quickAlertFalse.msg,
                  quickAlertFalse.type);
            }
          });
        }
      },
    );
  }

  void deleteAction(WidgetRef ref, int idPelajaran, String namaPelajaran) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
                child: Text(
              'Hapus Data\n$namaPelajaran?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            )),
            content: const Text(
              'Perhatian! Menghapus data Mata Pelajaran akan mengakibatkan Mata Pelajaran jam tertentu dijadwal mingguan yang menggunakan data ini akan di-HAPUS',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  ItemQuickAlert quickAlertTrue = ItemQuickAlert(
                      title: 'Berhasil',
                      msg: 'Data berhasil dihapus.',
                      type: QuickAlertType.success);
                  ItemQuickAlert quickAlertFalse = ItemQuickAlert(
                      title: 'Gagal',
                      msg: 'Data gagal dihapus.',
                      type: QuickAlertType.error);
                  ref
                      .read(mapelRepositoryProvider)
                      .deleteMapel(idPelajaran)
                      .then((value) {
                    if (value) {
                      _updateController(ref);
                      ref
                          .read(dataLoadedKelasProvider.notifier)
                          .setListJumlahMapelDecrement(idKelas);
                      Navigator.of(context).pop();
                      _showQuickAlert(quickAlertTrue.title, quickAlertTrue.msg,
                          quickAlertTrue.type);
                    } else {
                      Navigator.of(context).pop();
                      _showQuickAlert(quickAlertFalse.title,
                          quickAlertFalse.msg, quickAlertFalse.type);
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white70,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                child: const Text('Hapus'),
              ),
            ],
          );
        });
  }

  Widget _itemCardPelajaran(
    WidgetRef ref,
    String namaPelajaran,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      width: MediaQuery.of(context).size.width - 20,
      height: 62,
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
              // ignore: sort_child_properties_last
              child: Image.asset('images/Icon_book.png'),
              width: 70,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
                border: Border.all(color: Colors.black, width: 2),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              width: MediaQuery.of(context).size.width - 70 - 60,
              height: 66,
              alignment: Alignment.centerLeft,
              child: Text(
                namaPelajaran,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  void _showModalBottomSheet(
      {required WidgetRef ref,
      required String textTitle,
      required String textButton,
      required String initialText,
      required onPress}) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return _addOrUpdatePelajaran(
            ref: ref,
            text: textTitle,
            textButton: textButton,
            onPressButton: onPress,
            initialText: initialText,
          );
        });
  }

  Widget _addOrUpdatePelajaran(
      {required WidgetRef ref,
      required String text,
      required String textButton,
      required Function(Mapel) onPressButton,
      required String initialText}) {
    textNamaPelajaran.text = '';
    if (!_inputAktif) {
      _inputNamaPelajaran = initialText;
      _inputAktif = true;
    }
    textNamaPelajaran.text = _inputNamaPelajaran;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Form(
      key: _formKey,
      child: Padding(
        padding: mediaQueryData.viewInsets,
        child: SingleChildScrollView(
          child: Container(
            height: 210,
            margin: const EdgeInsets.all(30),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.green,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black54,
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: Offset(0, 4)),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
                TextFormField(
                  maxLength: 16,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    labelText: 'Nama Mata Pelajaran',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  controller: textNamaPelajaran,
                  onChanged: (value) {
                    _inputNamaPelajaran = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Tolong diisi';
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Batal')),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Mapel mapel = Mapel(
                                idKelas: idKelas,
                                namaMapel: textNamaPelajaran.text);
                            onPressButton(mapel);
                            _updateController(ref);
                            Navigator.pop(context);
                          }
                        },
                        child: Text(textButton)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showQuickAlert(String title, String msg, QuickAlertType type) {
    QuickAlert.show(
      title: title,
      text: msg,
      context: context,
      type: type,
    );
  }
}
