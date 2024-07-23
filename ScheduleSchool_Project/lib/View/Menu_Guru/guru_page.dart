import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Model/Repository/kode_guru_repository.dart';
import 'package:flutter_app2/Provider/provider_menu_jadwal_kelas.dart';
import 'package:flutter_app2/View/Menu_Guru/show_dropdown_kode_guru.dart';
import 'package:flutter_app2/View/Menu_Guru/radiobutton_status_kepala_sekolah.dart';
import 'package:flutter_app2/color_code_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quickalert/quickalert.dart';
import '../../Model/Repository/guru_repository.dart';
import '../../Provider/provider_menu_guru.dart';
import '../item_quick_alert.dart';
import 'initial_guru.dart';

// ignore: must_be_immutable
class GuruPage extends ConsumerWidget {
  GuruPage({Key? key}) : super(key: key);
  late BuildContext context;
  late bool pageVisit = false;
  late StreamController<List<Map<String, Object>>> _streamController =
      StreamController();

  late String _inputNamaGuru = '';
  late bool _inputAktif = false;
  late List<KodeGuru> dataKodeGuru;
  final _formKey = GlobalKey<FormState>();
  TextEditingController textNamaGuru = TextEditingController();
  KodeGuru selectKodeGuru = KodeGuru(kodeGuru: '', status: '');
  int statusKSTrue = 0;

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
            title: const Text('Guru'),
            elevation: 4,
            shadowColor: Colors.black,
            backgroundColor: Colors.lightBlueAccent,
          ),
          body: Stack(children: <Widget>[
            StreamBuilder<List<Map<String, Object>>>(
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
                        : _listGuru(ref, dataList);
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
                      InitialGuru initialGuru = InitialGuru(
                          idKodeGuru: '',
                          namaGuru: '',
                          statusKepalaSekolah: 'False',
                          kodeGuru: selectKodeGuru);
                      _showModalBottomSheet(
                          ref: ref,
                          textTitle: 'Tambah Data Guru',
                          textButton: 'Simpan',
                          initialGuru: initialGuru,
                          kodeGuru: dataKodeGuru,
                          onPress: (guru, idKodeGuru, kodeGuru) {
                            ref
                                .read(guruRepositoryProvider)
                                .addGuru(guru)
                                .then((value) {
                              if (value) {
                                ref
                                    .read(kodeGuruRepositoryProvider)
                                    .updateStatusKodeGuru(idKodeGuru, kodeGuru);
                                var dataListKodeGuru = ref
                                    .watch(kodeGuruRepositoryProvider)
                                    .getAllKodeGuruNotActive();
                                dataListKodeGuru
                                    .then((value) => dataKodeGuru = value);
                                _showQuickAlert(quickAlertTrue.title,
                                    quickAlertTrue.msg, quickAlertTrue.type);
                              } else {
                                _showQuickAlert(quickAlertFalse.title,
                                    quickAlertFalse.msg, quickAlertFalse.type);
                              }
                            });
                          },
                          statusKSTrue: statusKSTrue);
                    },
                  ),
                )),
          ])),
    );
  }

  void _updateController(WidgetRef ref) {
    var dataList =
        ref.watch(guruRepositoryProvider).getAllGuruToKodeGuruStream();
    var dataListKodeGuru =
        ref.watch(kodeGuruRepositoryProvider).getAllKodeGuruNotActive();
    dataList.listen((list) {
      _streamController.sink.add(list);
    });
    dataListKodeGuru.then((value) => dataKodeGuru = value);
  }

  Widget _listGuru(WidgetRef ref, List<Map<String, Object>> data) {
    statusKSTrue = (data[0]['status_kepala_sekolah_true'] as int);
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
                          ref,
                          (data[index]['guru'] as Guru).idGuru!,
                          (data[index]['guru'] as Guru),
                          (data[index]['kode_guru'] as KodeGuru));
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
                          ref,
                          (data[index]['guru'] as Guru).idGuru!,
                          (data[index]['guru'] as Guru),
                          (data[index]['kode_guru'] as KodeGuru));
                    },
                  ),
                ],
              ),
              child: _itemCardGuru(
                  ref,
                  (data[index]['guru'] as Guru).idGuru,
                  (data[index]['guru'] as Guru),
                  (data[index]['kode_guru'] as KodeGuru)));
        });
  }

  void editAction(WidgetRef ref, int idGuru, Guru guru, KodeGuru kodeGuru) {
    _inputAktif = false;
    ItemQuickAlert quickAlertTrue = ItemQuickAlert(
        title: 'Berhasil',
        msg: 'Data berhasil diperbarui.',
        type: QuickAlertType.success);
    ItemQuickAlert quickAlertFalse = ItemQuickAlert(
        title: 'Gagal', msg: 'Data sudah ada.', type: QuickAlertType.error);
    int oldIdKodeGuru = kodeGuru.idKodeGuru!;
    KodeGuru oldKodeGuru = KodeGuru(
        idKodeGuru: kodeGuru.idKodeGuru!,
        kodeGuru: kodeGuru.kodeGuru,
        status: 'Kosong');
    InitialGuru initialGuru = InitialGuru(
        idKodeGuru: guru.idKodeGuru.toString(),
        namaGuru: guru.namaGuru!,
        statusKepalaSekolah: guru.statusKepalaSekolah!,
        kodeGuru: kodeGuru);
    List<KodeGuru> dataKodeGuru2 = List<KodeGuru>.from(dataKodeGuru);
    dataKodeGuru2.add(kodeGuru);
    dataKodeGuru2.sort((a, b) => a.kodeGuru!.compareTo(b.kodeGuru!));
    _showModalBottomSheet(
      ref: ref,
      textTitle: 'Edit Data Guru',
      textButton: 'Ubah',
      initialGuru: initialGuru,
      kodeGuru: dataKodeGuru2,
      onPress: (guru, idKodeGuru, kodeGuru) {
        ref.read(guruRepositoryProvider).updateGuru(idGuru, guru).then((value) {
          if (value) {
            ref
                .read(kodeGuruRepositoryProvider)
                .updateStatusKodeGuru(oldIdKodeGuru, oldKodeGuru);
            ref
                .read(kodeGuruRepositoryProvider)
                .updateStatusKodeGuru(idKodeGuru, kodeGuru);
            var dataListKodeGuru =
                ref.watch(kodeGuruRepositoryProvider).getAllKodeGuruNotActive();
            dataListKodeGuru.then((value) => dataKodeGuru = value);
            _showQuickAlert(
                quickAlertTrue.title, quickAlertTrue.msg, quickAlertTrue.type);
          } else {
            _showQuickAlert(quickAlertFalse.title, quickAlertFalse.msg,
                quickAlertFalse.type);
          }
        });
      },
      statusKSTrue:
          (guru.statusKepalaSekolah == 'False' && statusKSTrue == 1) ? 1 : 0,
    );
  }

  void deleteAction(WidgetRef ref, int idGuru, Guru guru, KodeGuru kodeGuru) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
                child: Text(
              'Hapus Data\nKode Guru ${kodeGuru.kodeGuru}?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            )),
            content: const Text(
              'Perhatian! Menghapus data Guru akan mengakibatkan data Guru jam tertentu dijadwal mingguan yang menggunakan data ini akan di-HAPUS',
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
                      .read(guruRepositoryProvider)
                      .deleteGuru(idGuru)
                      .then((value) {
                    ref.read(jadwalRepositoryProvider).updateJadwalGuru(idGuru);
                    if (value) {
                      KodeGuru kodeGuruNotActive = KodeGuru(
                          idKodeGuru: kodeGuru.idKodeGuru,
                          kodeGuru: kodeGuru.kodeGuru,
                          status: 'Kosong');
                      ref.read(kodeGuruRepositoryProvider).updateStatusKodeGuru(
                          kodeGuru.idKodeGuru!, kodeGuruNotActive);
                      _updateController(ref);
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

  Widget _itemCardGuru(
    WidgetRef ref,
    int? idGuru,
    Guru guru,
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
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              width: MediaQuery.of(context).size.width - 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                color: colorCodeMap[kodeGuru.kodeGuru],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 120,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      guru.namaGuru!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13,
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
                          fontSize: 11,
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

  void _showModalBottomSheet(
      {required WidgetRef ref,
      required String textTitle,
      required String textButton,
      required InitialGuru initialGuru,
      required List<KodeGuru> kodeGuru,
      required onPress,
      required int statusKSTrue}) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return _addOrUpdateGuru(
            ref: ref,
            text: textTitle,
            textButton: textButton,
            onPressButton: onPress,
            kodeGuru: kodeGuru,
            initialGuru: initialGuru,
            statusKSTrue: statusKSTrue,
          );
        });
  }

  Widget _addOrUpdateGuru(
      {required WidgetRef ref,
      required String text,
      required String textButton,
      required Function(Guru, int, KodeGuru) onPressButton,
      required List<KodeGuru> kodeGuru,
      required InitialGuru initialGuru,
      required int statusKSTrue}) {
    textNamaGuru.text = '';
    if (!_inputAktif) {
      _inputNamaGuru = initialGuru.namaGuru;
      ref.read(selectDataGuruProvider.notifier).selectKodeGuru =
          initialGuru.kodeGuru;
      ref.read(selectDataGuruProvider.notifier).statusKepalaSekolah =
          initialGuru.statusKepalaSekolah;
      _inputAktif = true;
    }
    textNamaGuru.text = _inputNamaGuru;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: mediaQueryData.viewInsets,
      child: SingleChildScrollView(
        child: Container(
          height: statusKSTrue == 0 ? 360 : 290,
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
                TextFormField(
                  maxLength: 30,
                  onChanged: (value) {
                    _inputNamaGuru = value;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    labelText: 'Nama Guru',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  controller: textNamaGuru,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Tolong diisi';
                    }
                    return null;
                  },
                ),
                ShowDropdownKodeGuru(kodeGuru, selectKodeGuru),
                statusKSTrue == 0
                    ? const Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status Kepala Sekolah : ',
                                textAlign: TextAlign.left),
                            RadioButtonStatusKepalaSekolah(),
                          ],
                        ),
                      )
                    : Container(),
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
                            int? idKodeGuru = ref
                                .watch(selectDataGuruProvider)
                                .selectKodeGuru
                                .idKodeGuru;
                            String kodeNamaGuru = ref
                                .watch(selectDataGuruProvider)
                                .selectKodeGuru
                                .kodeGuru!;
                            String statusKepalaSekolah = ref
                                .watch(selectDataGuruProvider)
                                .statusKepalaSekolah;
                            Guru guru = Guru(
                                idKodeGuru: idKodeGuru!,
                                namaGuru: textNamaGuru.text,
                                statusKepalaSekolah: statusKepalaSekolah);
                            KodeGuru kodeGuru = KodeGuru(
                                kodeGuru: kodeNamaGuru, status: 'Aktif');
                            onPressButton(guru, idKodeGuru, kodeGuru);
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
