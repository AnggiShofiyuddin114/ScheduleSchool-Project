import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app2/Model/Repository/model_jadwal_repository.dart';
import 'package:flutter_app2/View/Menu_Model_Jadwal/show_checkbox_days.dart';
import 'package:flutter_app2/View/Menu_Model_Jadwal/show_time_picker_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../Provider/provider_menu_model_jadwal.dart';
import '../item_quick_alert.dart';
import 'atur_model_jadwal_page.dart';
import 'initial_model_jadwal.dart';

// ignore: must_be_immutable
class ModelJadwalPage extends ConsumerWidget {
  ModelJadwalPage({Key? key}) : super(key: key);
  late BuildContext context;
  late bool pageVisit = false;
  late StreamController<List<ModelJadwal>> _streamController =
      StreamController();

  late String _inputNamaModel = '';
  late String _inputJumlahJamPerhari = '';
  late String _inputDurasiPerjam = '';
  late String _inputTahunAjaran = '';
  late bool _inputAktif = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController textNamaModel = TextEditingController();
  TextEditingController textJumlahJamPerHari = TextEditingController();
  TextEditingController textDurasiPerHari = TextEditingController();
  TextEditingController textTahunAjaran = TextEditingController();
  late List<ModelJadwal> dataModel;

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
            title: const Text('Model Jadwal'),
            elevation: 4,
            shadowColor: Colors.black,
            backgroundColor: Colors.lightBlueAccent,
          ),
          body: Stack(children: <Widget>[
            StreamBuilder<List<ModelJadwal>>(
                stream: _streamController.stream,
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text("Loading"));
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error'));
                  } else {
                    dataModel = snapshot.data ?? [];
                    return dataModel.isEmpty
                        ? const Center(
                            child: Text('Kosong'),
                          )
                        : _listModelJadwal(ref, dataModel);
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
                          msg: 'Nama Model sudah ada.',
                          type: QuickAlertType.error);
                      InitialModelJadwal initialModelJadwal =
                          InitialModelJadwal(
                              namaModel: '',
                              waktuMulai: '00:00',
                              jumlahJamPerhari: '',
                              durasiPerjam: '',
                              tahunAjaran: '',
                              statusHariLibur: List<String>.filled(7, 'FALSE'));
                      _showModalBottomSheet(
                        ref: ref,
                        textTitle: 'Tambah Model Baru',
                        textButton: 'Simpan',
                        initialModelJadwal: initialModelJadwal,
                        onPress: (modelJadwal) {
                          ref
                              .read(modelJadwalRepositoryProvider)
                              .addModelJadwal(modelJadwal)
                              .then((value) {
                            Navigator.pop(context);
                            if (value) {
                              _updateController(ref);
                              _showQuickAlert(quickAlertTrue.title,
                                  quickAlertTrue.msg, quickAlertTrue.type);
                            } else {
                              _showQuickAlert(quickAlertFalse.title,
                                  quickAlertFalse.msg, quickAlertFalse.type);
                            }
                          });
                        },
                      );
                    },
                  ),
                )),
          ])),
    );
  }

  void _updateController(WidgetRef ref) {
    var dataList = ref.watch(modelJadwalRepositoryProvider).getAllModelJadwal();
    dataList.listen((list) {
      _streamController.sink.add(list);
    });
  }

  Widget _listModelJadwal(WidgetRef ref, List<ModelJadwal> data) {
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
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.blue,
                    icon: Icons.edit,
                    label: 'Atur Model',
                    onPressed: (context) {
                      ref
                          .read(selectDataModelJadwalProvider.notifier)
                          .tahunAjaran = data[index].tahunAjaran.toString();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AturModelJadwalPage(
                                    idModel: data[index].idModel,
                                    namaModel: data[index].namaModel,
                                  ))).then((value) {
                        if (ref
                                .read(selectDataModelJadwalProvider.notifier)
                                .tahunAjaran !=
                            data[index].tahunAjaran.toString()) {
                          _updateController(ref);
                        }
                      });
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
                          ref, data[index].idModel, data[index].namaModel);
                    },
                  ),
                ],
              ),
              child: _itemCardModelJadwal(ref, data[index]));
        });
  }

  void deleteAction(WidgetRef ref, int? idModel, String namaModel) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(
                child: Text(
              'Hapus Data',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            )),
            content: Text(
              'Apakah Anda yakin ingin menghapus Model Jadwal $namaModel ini?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.red),
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
                      .read(modelJadwalRepositoryProvider)
                      .deleteModelJadwal(idModel!)
                      .then((value) {
                    Navigator.of(context).pop();
                    if (value) {
                      _updateController(ref);
                      _showQuickAlert(quickAlertTrue.title, quickAlertTrue.msg,
                          quickAlertTrue.type);
                    } else {
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
              child: Image.asset(
                'images/Icon_schedule12.png',
                color: Colors.black,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
              width: MediaQuery.of(context).size.width - 100,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                color: Colors.lightGreen,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
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
          ],
        ),
      ]),
    );
  }

  void _showModalBottomSheet(
      {required WidgetRef ref,
      required String textTitle,
      required String textButton,
      required InitialModelJadwal initialModelJadwal,
      required onPress}) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return _addModelJadwal(
            ref: ref,
            text: textTitle,
            textButton: textButton,
            onPressButton: onPress,
            initialModelJadwal: initialModelJadwal,
          );
        });
  }

  Widget _addModelJadwal(
      {required WidgetRef ref,
      required String text,
      required String textButton,
      required onPressButton,
      required InitialModelJadwal initialModelJadwal}) {
    textNamaModel.text = '';
    textJumlahJamPerHari.text = '';
    textDurasiPerHari.text = '';
    textTahunAjaran.text = '';
    if (!_inputAktif) {
      _inputNamaModel = initialModelJadwal.namaModel;
      ref.read(selectDataModelJadwalProvider.notifier).waktuMulai =
          initialModelJadwal.waktuMulai;
      _inputJumlahJamPerhari = initialModelJadwal.jumlahJamPerhari;
      _inputDurasiPerjam = initialModelJadwal.durasiPerjam;
      _inputTahunAjaran = initialModelJadwal.tahunAjaran;
      ref.read(selectDataModelJadwalProvider.notifier).statusHariLibur =
          initialModelJadwal.statusHariLibur;
      final List<String> hari = [
        'Senin',
        'Selasa',
        'Rabu',
        'Kamis',
        'Jumat',
        'Sabtu',
        'Minggu'
      ];
      List<String> hariTrue = [];
      for (int i = 0; i < 7; i++) {
        if (ref
                .read(selectDataModelJadwalProvider.notifier)
                .statusHariLibur[i] ==
            'TRUE') {
          hariTrue.add(hari[i]);
        }
      }
      ref.watch(selectDataModelJadwalProvider).selectHariLibur = hariTrue;
      _inputAktif = true;
    }
    textNamaModel.text = _inputNamaModel;
    textJumlahJamPerHari.text = _inputJumlahJamPerhari;
    textDurasiPerHari.text = _inputDurasiPerjam;
    textTahunAjaran.text = _inputTahunAjaran;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: mediaQueryData.viewInsets,
      child: SingleChildScrollView(
        child: Container(
          height: 580,
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
                      fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  style: const TextStyle(fontSize: 11),
                  maxLength: 30,
                  onChanged: (value) {
                    _inputNamaModel = value;
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    labelText: 'Nama Model',
                    labelStyle:
                        const TextStyle(color: Colors.black87, fontSize: 11),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 11),
                  ),
                  controller: textNamaModel,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Tolong diisi';
                    } else if (dataModel
                        .where((element) => element.namaModel == value)
                        .toList()
                        .isNotEmpty) {
                      return 'Nama Model sudah ada';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 2,
                ),
                const ShowTimePickerField(),
                const SizedBox(
                  height: 2,
                ),
                TextFormField(
                  style: const TextStyle(fontSize: 11),
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  onChanged: (value) {
                    _inputJumlahJamPerhari = value;
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    labelText: 'Jumlah Jam Per Hari',
                    labelStyle:
                        const TextStyle(color: Colors.black87, fontSize: 11),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 11),
                  ),
                  controller: textJumlahJamPerHari,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Tolong diisi';
                    } else if (int.parse(value) == 0 || int.parse(value) > 12) {
                      return 'Hanya 1 - 12';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 143,
                      child: TextFormField(
                        style: const TextStyle(fontSize: 11),
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        onChanged: (value) {
                          _inputDurasiPerjam = value;
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          labelText: 'Durasi Per Jam',
                          labelStyle: const TextStyle(
                              color: Colors.black87, fontSize: 11),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 11),
                        ),
                        controller: textDurasiPerHari,
                        validator: (value) {
                          if (value!.isEmpty || int.parse(value) == 0) {
                            return 'Tolong diisi';
                          }
                          return null;
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: Text(
                        '  Menit',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                TextFormField(
                  maxLength: 4,
                  style: const TextStyle(fontSize: 11),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4)
                  ],
                  onChanged: (value) {
                    _inputTahunAjaran = value;
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    labelText: 'Tahun Ajaran',
                    labelStyle:
                        const TextStyle(color: Colors.black87, fontSize: 11),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 11),
                  ),
                  controller: textTahunAjaran,
                  validator: (value) {
                    if (value!.isEmpty || int.parse(value) == 0) {
                      return 'Tolong diisi';
                    } else if (value.length != 4) {
                      return 'Harus 4 digit';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 2,
                ),
                const ShowCheckBoxDays(),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Batal',
                          style: TextStyle(fontSize: 14),
                        )),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            String waktuMulai = ref
                                .watch(selectDataModelJadwalProvider)
                                .waktuMulai;
                            List<String> statusHariLibur = ref
                                .watch(selectDataModelJadwalProvider)
                                .statusHariLibur;
                            ModelJadwal modelJadwal = ModelJadwal(
                                idDataSekolah: 0,
                                namaModel: textNamaModel.text,
                                waktuMulai: waktuMulai,
                                jumlahJamPerhari:
                                    int.parse(textJumlahJamPerHari.text),
                                durasiPerjam: int.parse(textDurasiPerHari.text),
                                tahunAjaran: int.parse(textTahunAjaran.text),
                                statusHariLibur: statusHariLibur);
                            onPressButton(modelJadwal);
                          }
                        },
                        child: Text(
                          textButton,
                          style: const TextStyle(fontSize: 14),
                        )),
                  ],
                ),
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
