import 'package:flutter/material.dart';
import 'package:flutter_app2/Model/Repository/jadwal_repository.dart';
import 'package:flutter_app2/Model/Repository/jenis_kegiatan_repository.dart';
import 'package:flutter_app2/Model/Repository/kelas_repository.dart';
import 'package:flutter_app2/Model/Repository/kode_guru_repository.dart';
import 'package:flutter_app2/View/Menu_Model_Jadwal/show_dropdown_jenis_kegiatan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../Model/Repository/guru_repository.dart';
import '../../Model/Repository/hari_repository.dart';
import '../../Model/Repository/mapel_repository.dart';
import '../../Provider/provider_menu_jadwal_kelas.dart';
import '../../Provider/provider_menu_model_jadwal.dart';
import '../item_quick_alert.dart';
import 'initial_data_model_jadwal.dart';

// ignore: must_be_immutable
class ItemModelJadwal extends ConsumerStatefulWidget {
  BuildContext mainContext;
  // ignore: non_constant_identifier_names
  List<dynamic> all_jenis_kegiatan;
  int no;
  Jadwal jadwal;
  Kelas kelas;
  Guru guru;
  KodeGuru kodeGuru;
  Mapel mapel;
  Hari hari;
  JenisKegiatan jenisKegiatan;
  String allId;
  List dataNext;
  int durasi;
  ItemModelJadwal(
      {Key? key,
      required this.mainContext,
      // ignore: non_constant_identifier_names
      required this.all_jenis_kegiatan,
      required this.no,
      required this.jadwal,
      required this.kelas,
      required this.guru,
      required this.kodeGuru,
      required this.mapel,
      required this.hari,
      required this.jenisKegiatan,
      required this.durasi,
      required this.allId,
      required this.dataNext})
      : super(key: key);

  @override
  ConsumerState<ItemModelJadwal> createState() => _ItemModelJadwalState();
}

class _ItemModelJadwalState extends ConsumerState<ItemModelJadwal> {
  @override
  late BuildContext context;
  TextEditingController textDurasiJam = TextEditingController();
  late bool _inputAktif = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    this.context = widget.mainContext;
    return Card(
      color: Colors.black,
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(1),
        height: 76,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(11),
                    topRight: Radius.circular(11)),
              ),
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // ignore: sort_child_properties_last
                    child: Text(
                      widget.no != 0 ? widget.no.toString() : '',
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(11)),
                    ),
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 1, bottom: 1),
                    width: 42,
                  ),
                  Text(
                    '${widget.jadwal.jamMulai} - ${widget.jadwal.jamSelesai}',
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            GestureDetector(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: widget.jadwal.idJenisKegiatan == 0
                      ? Colors.red
                      : Colors.white70,
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(11),
                      bottomLeft: Radius.circular(11)),
                ),
                height: 54,
                child: Center(
                    child: Text(widget.jenisKegiatan.namaJenisKegiatan!)),
              ),
              onTap: () {
                editAction(ref, widget.allId, widget.jenisKegiatan);
              },
            ),
          ],
        ),
      ),
    );
  }

  void editAction(
      WidgetRef ref, String allID, JenisKegiatan selectJenisKegiatan) {
    _inputAktif = false;
    InitialDataModelJadwal initialDataModelJadwal = InitialDataModelJadwal(
        selectJenisKegiatan: selectJenisKegiatan,
        durasiJam: widget.durasi.toString());
    _showModalBottomSheet(
      ref: ref,
      textTitle: 'Edit Jadwal',
      textButton: 'Simpan',
      initialDataModelJadwal: initialDataModelJadwal,
    );
  }

  void _showModalBottomSheet(
      {required WidgetRef ref,
      required String textTitle,
      required String textButton,
      required InitialDataModelJadwal initialDataModelJadwal}) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return _addOrUpdateItemModelJadwal(
            ref: ref,
            text: textTitle,
            textButton: textButton,
            initialDataModelJadwal: initialDataModelJadwal,
          );
        });
  }

  Widget _addOrUpdateItemModelJadwal(
      {required WidgetRef ref,
      required String text,
      required String textButton,
      required InitialDataModelJadwal initialDataModelJadwal}) {
    textDurasiJam.text = '';
    if (!_inputAktif) {
      ref.read(selectEditDataModelJadwalProvider.notifier).selectJenisKegiatan =
          widget.all_jenis_kegiatan[
              initialDataModelJadwal.selectJenisKegiatan.idJenisKegiatan!];
      ref.read(selectEditDataModelJadwalProvider.notifier).durasiJam =
          initialDataModelJadwal.durasiJam;
      _inputAktif = true;
    }
    textDurasiJam.text =
        ref.read(selectEditDataModelJadwalProvider.notifier).durasiJam;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Form(
      key: _formKey,
      child: Padding(
        padding: mediaQueryData.viewInsets,
        child: SingleChildScrollView(
          child: Container(
            height: 320,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    text,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  'Jam : ${widget.jadwal.jamMulai} - ${widget.jadwal.jamSelesai}',
                  style: const TextStyle(fontSize: 14),
                ),
                ShowDropdownJenisKegiatan(widget.all_jenis_kegiatan),
                TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    labelText: 'Durasi Jam',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  controller: textDurasiJam,
                  onChanged: (value) {
                    ref
                        .read(selectEditDataModelJadwalProvider.notifier)
                        .durasiJam = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Tolong diisi';
                    } else if (value == '0') {
                      return 'Tidak boleh nol';
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
                            JenisKegiatan selectJenisKegiatan = ref
                                .read(
                                    selectEditDataModelJadwalProvider.notifier)
                                .selectJenisKegiatan;
                            String durasiJam = ref
                                .read(
                                    selectEditDataModelJadwalProvider.notifier)
                                .durasiJam;
                            if (initialDataModelJadwal
                                        .selectJenisKegiatan.idJenisKegiatan !=
                                    selectJenisKegiatan.idJenisKegiatan ||
                                initialDataModelJadwal.durasiJam != durasiJam) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Center(
                                          child: Text(
                                        'Apakah Anda ingin mengubah Jenis Kegiatan "${initialDataModelJadwal.selectJenisKegiatan.namaJenisKegiatan}" menjadi "${selectJenisKegiatan.namaJenisKegiatan}"?',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      )),
                                      content: const Text(
                                        'Perhatian! Perubahan Jadwal Kegiatan akan mengakibatkan Mata Pelajaran jam tertentu dijadwal mingguan yang menggunakan model ini akan di-HAPUS',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.red),
                                      ),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15))),
                                          child: const Text('Tidak'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            ItemQuickAlert quickAlertTrue =
                                                ItemQuickAlert(
                                                    title: 'Berhasil',
                                                    msg:
                                                        'Data berhasil diperbarui.',
                                                    type:
                                                        QuickAlertType.success);
                                            ItemQuickAlert quickAlertFalse =
                                                ItemQuickAlert(
                                                    title: 'Gagal',
                                                    msg: 'Data sudah ada.',
                                                    type: QuickAlertType.error);
                                            ref
                                                .read(jadwalRepositoryProvider)
                                                .updateAllJadwal(
                                                    selectJenisKegiatan,
                                                    durasiJam,
                                                    initialDataModelJadwal
                                                        .durasiJam,
                                                    widget.jadwal.jamMulai,
                                                    widget.allId,
                                                    widget.dataNext)
                                                .then((value) {
                                              if (value) {
                                                _inputAktif = false;
                                                _showQuickAlert(
                                                    quickAlertTrue.title,
                                                    quickAlertTrue.msg,
                                                    quickAlertTrue.type);
                                                // ignore: unused_result
                                                ref.refresh(
                                                    modelJadwalRepositoryFutureProvider(
                                                        widget.jadwal.idModel));
                                              } else {
                                                _showQuickAlert(
                                                    quickAlertFalse.title,
                                                    quickAlertFalse.msg,
                                                    quickAlertFalse.type);
                                              }
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white70,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15))),
                                          child: const Text('Iya'),
                                        ),
                                      ],
                                    );
                                  });
                            }
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
