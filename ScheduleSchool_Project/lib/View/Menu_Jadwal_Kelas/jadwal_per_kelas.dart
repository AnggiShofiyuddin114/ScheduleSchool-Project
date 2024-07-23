import 'package:flutter/material.dart';
import 'package:flutter_app2/Model/Repository/kode_guru_repository.dart';
import 'package:flutter_app2/View/Menu_Jadwal_Kelas/initial_data_jadwal_per_kelas.dart';
import 'package:flutter_app2/View/Menu_Jadwal_Kelas/show_dropdown_durasi_pelajaran.dart';
import 'package:flutter_app2/View/Menu_Jadwal_Kelas/show_dropdown_guru.dart';
import 'package:flutter_app2/View/Menu_Jadwal_Kelas/show_dropdown_mapel_kelas.dart';
import 'package:flutter_app2/color_code_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../Model/Repository/guru_repository.dart';
import '../../Model/Repository/jadwal_repository.dart';
import '../../Model/Repository/mapel_repository.dart';
import '../../Provider/provider_menu_jadwal_kelas.dart';
import 'header_group.dart';

// ignore: must_be_immutable
class JadwalPerKelas extends ConsumerStatefulWidget {
  BuildContext mainContext;
  int idModel;
  int jumlahJamPerhari;
  List<String> listGroups;
  List dataJadwalKelas;
  List<dynamic> dataMapelKelas;
  List<Map<String, Object>> allDataGuru;
  int index;
  List allDataJadwalKelas;
  final List<ScrollController> _lscrollController;

  JadwalPerKelas(
      this.mainContext,
      this.idModel,
      this.jumlahJamPerhari,
      this.listGroups,
      this.dataJadwalKelas,
      this.dataMapelKelas,
      this.allDataGuru,
      this.index,
      this.allDataJadwalKelas,
      this._lscrollController,
      {Key? key})
      : super(key: key);

  @override
  ConsumerState<JadwalPerKelas> createState() => _JadwalPerKelasState();
}

class _JadwalPerKelasState extends ConsumerState<JadwalPerKelas>
    with AutomaticKeepAliveClientMixin {
  TextEditingController textDurasiJam = TextEditingController();
  late bool _inputAktif = false;
  final _formKey = GlobalKey<FormState>();
  late List batasScroll;

  @override
  void initState() {
    batasScroll = List.generate(
        widget.listGroups.length + 1,
        (index) =>
            (((76 + 12) * widget.jumlahJamPerhari) * index + 45 * (index - 1)) *
            (index == 0 ? 0 : 1));
    widget._lscrollController[widget.index].addListener(() {
      if (widget.index - 1 >= 0) {
        if (widget._lscrollController[widget.index - 1].positions.isNotEmpty) {
          if (widget._lscrollController[widget.index - 1].position.pixels !=
              widget._lscrollController[widget.index].position.pixels) {
            widget._lscrollController[widget.index - 1].jumpTo(
                widget._lscrollController[widget.index].position.pixels);
          }
        }
      }
      if (widget.index + 1 < widget._lscrollController.length) {
        if (widget._lscrollController[widget.index + 1].positions.isNotEmpty) {
          if (widget._lscrollController[widget.index + 1].position.pixels !=
              widget._lscrollController[widget.index].position.pixels) {
            widget._lscrollController[widget.index + 1].jumpTo(
                widget._lscrollController[widget.index].position.pixels);
          }
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setLScrollController();
    });
    super.initState();
  }

  void setLScrollController() {
    if (widget.index - 1 >= 0) {
      if (widget._lscrollController[widget.index - 1].positions.isNotEmpty) {
        if (widget._lscrollController[widget.index - 1].position.pixels !=
            widget._lscrollController[widget.index].position.pixels) {
          widget._lscrollController[widget.index].jumpTo(
              widget._lscrollController[widget.index - 1].position.pixels);
        }
      }
    }
    if (widget.index + 1 < widget._lscrollController.length) {
      if (widget._lscrollController[widget.index + 1].positions.isNotEmpty) {
        if (widget._lscrollController[widget.index + 1].position.pixels !=
            widget._lscrollController[widget.index].position.pixels) {
          widget._lscrollController[widget.index].jumpTo(
              widget._lscrollController[widget.index + 1].position.pixels);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Map dataPerHari = {};
    for (String i in widget.listGroups) {
      var data = widget.dataJadwalKelas
          .where(
              (item) => (item['group'].split(':')[1] == i && item['no'] != 0))
          .toList();
      List allId = data
          .map((data) => (data['jadwal'] as Jadwal).idJadwal)
          .toSet()
          .toList();
      dataPerHari[i] = allId;
    }
    return Stack(
      children: [
        GroupedListView(
          controller: widget._lscrollController[widget.index],
          elements: widget.dataJadwalKelas,
          groupBy: ((element) => element['group']),
          groupComparator: ((value1, value2) => value1.compareTo(value2)),
          itemComparator: (item1, item2) =>
              item1['id_jadwal'].compareTo(item2['id_jadwal']),
          useStickyGroupSeparators: true,
          groupSeparatorBuilder: (String value) {
            String text = value.split(':')[1];
            ref.read(currentGroupsProvider.notifier).currentGroup =
                widget.listGroups[batasScroll
                    .map((e) =>
                        e >
                        widget._lscrollController[widget.index].position.pixels)
                    .toList()
                    .lastIndexOf(false)];
            // ignore: unused_result
            ref.refresh(currentGroupsStreamProvider);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
          },
          itemBuilder: (c, element) {
            var dataHari = dataPerHari[element['hari'].namaHari];
            int index = dataHari.indexOf(element['jadwal'].idJadwal);
            List id3Next = element['no'] != 0
                ? dataHari.sublist(index,
                    index + 3 > dataHari.length ? dataHari.length : index + 3)
                : [];
            List data3Next = widget.allDataJadwalKelas
                .where((data) => id3Next.contains(data['jadwal'].idJadwal))
                .toList();
            List indexId3Next = widget.allDataJadwalKelas
                .asMap()
                .entries
                .where(
                    (entry) => id3Next.contains(entry.value['jadwal'].idJadwal))
                .map((entry) => entry.key)
                .toList();
            return ItemJadwal(
                mainContext: widget.mainContext,
                no: element['no'],
                jadwal: element['jadwal'],
                kelas: element['kelas'],
                guru: element['guru'],
                kodeGuru: element['kode_guru'],
                mapel: element['mapel'],
                hari: element['hari'],
                jenisKegiatan: element['jenis_kegiatan'],
                dataMapelKelas: widget.dataMapelKelas,
                allDataGuru: widget.allDataGuru,
                data3Next: data3Next,
                indexId3Next: indexId3Next,
                allDataJadwalKelas: widget.allDataJadwalKelas);
          },
        ),
        const HeaderGroup(),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget ItemJadwal(
      {required mainContext,
      required no,
      required jadwal,
      required kelas,
      required guru,
      required kodeGuru,
      required mapel,
      required hari,
      required jenisKegiatan,
      required dataMapelKelas,
      required allDataGuru,
      required data3Next,
      required indexId3Next,
      required allDataJadwalKelas}) {
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
                      no == 0 ? '' : '$no',
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
                    '${jadwal.jamMulai} - ${jadwal.jamSelesai}',
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                if (no != 0) {
                  editAction(ref, jadwal, hari, no, jadwal, guru, kodeGuru,
                      mapel, data3Next, indexId3Next);
                }
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 1, right: 10),
                decoration: BoxDecoration(
                  color: (jadwal.idGuru == null && jadwal.idMapel == null)
                      ? jadwal.idJenisKegiatan == 0
                          ? Colors.red
                          : Colors.white70
                      : colorCodeMap[kodeGuru.kodeGuru],
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(11),
                      bottomLeft: Radius.circular(11)),
                ),
                height: 54,
                child: (jadwal.idGuru == null && jadwal.idMapel == null)
                    ? (jadwal.idJenisKegiatan == 0
                        ? Container()
                        : Center(
                            child: Text(jenisKegiatan.namaJenisKegiatan!),
                          ))
                    : Row(
                        children: [
                          Container(
                              // ignore: sort_child_properties_last
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 12.0),
                                child: Text(
                                  kodeGuru.kodeGuru!,
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.black),
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(11)),
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 95,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // ignore: avoid_unnecessary_containers
                                Container(
                                  child: Text(
                                    guru.namaGuru!,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // ignore: avoid_unnecessary_containers
                                Container(
                                    child: Text(
                                  mapel.namaMapel!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void editAction(WidgetRef ref, Jadwal selectJadwal, hari, no, jadwal, guru,
      kodeGuru, mapel, data3Next, indexId3Next) {
    _inputAktif = false;
    InitialDataJadwalPerKelas initialDataJadwalPerKelas =
        InitialDataJadwalPerKelas(
            selectJadwal: selectJadwal,
            hari: hari,
            no: no,
            jadwal: jadwal,
            guru: guru,
            kodeGuru: kodeGuru,
            mapel: mapel,
            data3Next: data3Next,
            indexId3Next: indexId3Next);
    _showModalBottomSheet(
      ref: ref,
      textTitle: guru.namaGuru == null ? 'Tambah Jadwal' : 'Edit Jadwal',
      textButton: 'Simpan',
      initialDataJadwalPerKelas: initialDataJadwalPerKelas,
    );
  }

  void _showModalBottomSheet(
      {required WidgetRef ref,
      required String textTitle,
      required String textButton,
      required initialDataJadwalPerKelas}) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return _addOrUpdateJadwal(
            ref: ref,
            text: textTitle,
            textButton: textButton,
            initialDataJadwalPerKelas: initialDataJadwalPerKelas,
          );
        });
  }

  Widget _addOrUpdateJadwal(
      {required WidgetRef ref,
      required String text,
      required String textButton,
      required initialDataJadwalPerKelas}) {
    textDurasiJam.text = '';
    if (!_inputAktif) {
      _inputAktif = true;
    }
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Form(
      key: _formKey,
      child: Padding(
        padding: mediaQueryData.viewInsets,
        child: SingleChildScrollView(
          child: Container(
            height: 450,
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
                  '${initialDataJadwalPerKelas.hari.namaHari} Jam ke ${initialDataJadwalPerKelas.no} (${initialDataJadwalPerKelas.jadwal.jamMulai} - ${initialDataJadwalPerKelas.jadwal.jamSelesai})',
                  style: const TextStyle(fontSize: 14),
                ),
                ShowDropdownGuru(
                    widget.allDataGuru,
                    initialDataJadwalPerKelas.guru,
                    initialDataJadwalPerKelas.kodeGuru,
                    initialDataJadwalPerKelas.kodeGuru),
                ShowDropdownMapelKelas(
                    widget.dataMapelKelas, initialDataJadwalPerKelas.mapel),
                ShowDropdownDurasiPelajaran(
                    initialDataJadwalPerKelas.data3Next, 1),
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
                            Guru selectGuru =
                                ref.watch(selectDataJadwalProvider).guru!;
                            KodeGuru selectKodeGuru =
                                ref.watch(selectDataJadwalProvider).kodeGuru!;
                            Mapel selectMapelKelas =
                                ref.watch(selectDataJadwalProvider).mapelKelas!;
                            int selectDurasiPelajaran = ref
                                .watch(selectDataJadwalProvider)
                                .durasiPelajaran;
                            if (initialDataJadwalPerKelas.guru.namaGuru !=
                                    selectGuru.namaGuru ||
                                initialDataJadwalPerKelas.kodeGuru.kodeGuru !=
                                    selectKodeGuru.kodeGuru ||
                                initialDataJadwalPerKelas.mapel.namaMapel !=
                                    selectMapelKelas.namaMapel) {
                              updateAction(
                                  selectGuru,
                                  selectKodeGuru,
                                  selectMapelKelas,
                                  selectDurasiPelajaran,
                                  initialDataJadwalPerKelas.data3Next,
                                  initialDataJadwalPerKelas.indexId3Next,
                                  false);
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

  // ignore: unused_element
  _showQuickAlert(String title, String msg, QuickAlertType type) {
    QuickAlert.show(
      title: title,
      text: msg,
      context: context,
      type: type,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  bool get wantKeepAlive => true;

  void updateAction(selectGuru, selectKodeGuru, selectMapelKelas,
      selectDurasiPelajaran, data3Next, indexId3Next, statusBentrok) {
    ref
        .read(jadwalRepositoryProvider)
        .update3Jadwal(
            widget.idModel,
            selectGuru,
            selectKodeGuru,
            selectMapelKelas,
            selectDurasiPelajaran,
            data3Next,
            widget.allDataJadwalKelas,
            indexId3Next,
            statusBentrok: statusBentrok)
        .then((value) {
      int jumlahBentrok = value[1]
          .map((e) => e['status'])
          .toSet()
          .toList()
          .where((element) => element == 'gagal')
          .toList()
          .length;
      if (value[0] == true) {
        widget.allDataJadwalKelas = value[2];
        widget.allDataGuru = value[3];
        QuickAlert.show(
            title: 'Info',
            context: context,
            type: QuickAlertType.custom,
            showCancelBtn: jumlahBentrok != 0 ? true : false,
            cancelBtnText: 'Iya',
            confirmBtnText: jumlahBentrok != 0 ? 'Tidak' : 'Okay',
            onCancelBtnTap: jumlahBentrok != 0
                ? () {
                    var data3Next = value[1]
                        .where((e) => e['status'] == 'gagal')
                        .map((element) => element['data3Next'])
                        .toList();
                    var indexId3Next = value[1]
                        .where((e) => e['status'] == 'gagal')
                        .map((element) => element['indexId3Next'])
                        .toList();
                    Navigator.of(context, rootNavigator: true).pop();
                    updateAction(selectGuru, selectKodeGuru, selectMapelKelas,
                        selectDurasiPelajaran, data3Next, indexId3Next, true);
                  }
                : () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
            cancelBtnTextStyle: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            confirmBtnColor: Colors.green,
            widget: Column(
              children: [
                SizedBox(
                  height: 30 + 28.0 * value[1].length,
                  child: ListView.builder(
                      itemCount: value[1].length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Container(
                              // ignore: sort_child_properties_last
                              child: Icon(
                                value[1][index]['status'] == 'berhasil'
                                    ? Icons.check
                                    : Icons.close,
                                color: value[1][index]['status'] == 'berhasil'
                                    ? Colors.black
                                    : Colors.red,
                              ),
                              padding:
                                  const EdgeInsets.only(right: 2, bottom: 2),
                            ),
                            Expanded(
                                child: Container(
                              // ignore: sort_child_properties_last
                              child: Text(
                                value[1][index]['text'],
                                style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        value[1][index]['status'] == 'berhasil'
                                            ? Colors.black
                                            : Colors.red),
                              ),
                              padding: const EdgeInsets.only(bottom: 3),
                            ))
                          ],
                        );
                      }),
                ),
                Text(
                  jumlahBentrok != 0
                      ? 'Apakah Anda setuju untuk mengijinkan bentrok jadwal ini?'
                      : '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.red),
                )
              ],
            ));
      }
      ref.watch(selectDataJadwalProvider).clear();
      setState(() {});
    });
  }
}
