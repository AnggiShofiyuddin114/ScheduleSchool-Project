import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app2/Model/Repository/hari_libur_repository.dart';
import 'package:flutter_app2/View/item_quick_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../Provider/provider_menu_model_jadwal.dart';
import 'item_model_jadwal.dart';

class AturModelJadwalPage extends ConsumerStatefulWidget {
  final int? idModel;
  final String? namaModel;
  const AturModelJadwalPage(
      {Key? key, required this.idModel, required this.namaModel})
      : super(key: key);

  @override
  ConsumerState<AturModelJadwalPage> createState() =>
      _AturModelJadwalPageState();
}

class _AturModelJadwalPageState extends ConsumerState<AturModelJadwalPage>
    with AutomaticKeepAliveClientMixin {
  List<HariLibur> listHariLibur = [];
  List _elements = [];
  final ScrollController _lscrollController = ScrollController();
  TextEditingController textTahunAjaran = TextEditingController();
  late String _inputTahunAjaran = '';
  late bool _inputAktif = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ref.watch(modelJadwalRepositoryFutureProvider(widget.idModel)).when(
          data: (data) {
            _elements = data['all_data_per_jam']!;
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Model Jadwal (${widget.namaModel})',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w400),
                ),
                elevation: 4,
                shadowColor: Colors.black,
                backgroundColor: Colors.lightBlueAccent,
                actions: [
                  PopupMenuButton(
                      onSelected: (result) {
                        if (result == 'option 1') {
                          editAction(ref, widget.idModel!);
                        }
                      },
                      itemBuilder: (context) => [
                            const PopupMenuItem(
                                value: 'option 1',
                                child: Text('Ganti Tahun Ajaran'))
                          ]),
                ],
              ),
              body: Stack(
                children: [
                  GroupedListView(
                    controller: _lscrollController,
                    elements: _elements,
                    groupBy: ((element) => element['group']),
                    groupComparator: ((value1, value2) =>
                        value1.compareTo(value2)),
                    itemComparator: (item1, item2) =>
                        item1['id_jadwal'].compareTo(item2['id_jadwal']),
                    useStickyGroupSeparators: false,
                    groupSeparatorBuilder: (String value) =>
                        const SizedBox.shrink(),
                    itemBuilder: (c, element) {
                      return ItemModelJadwal(
                        mainContext: context,
                        all_jenis_kegiatan: data['all_jenis_kegiatan']!,
                        no: element['no'],
                        jadwal: element['jadwal'],
                        kelas: element['kelas'],
                        guru: element['guru'],
                        kodeGuru: element['kode_guru'],
                        mapel: element['mapel'],
                        hari: element['hari'],
                        jenisKegiatan: element['jenis_kegiatan'],
                        durasi: element['durasi'],
                        allId: element['all_id_per_jam'],
                        dataNext: element['data_next'],
                      );
                    },
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) => Scaffold(
            body: Center(
                child: Text(
              error.toString(),
              style: const TextStyle(fontSize: 5),
            )),
          ),
          loading: () => const Scaffold(
            body: Center(child: Text("Loading")),
          ),
        );
  }

  void editAction(WidgetRef ref, int idModel) {
    _inputAktif = false;
    ItemQuickAlert quickAlertTrue = ItemQuickAlert(
        title: 'Berhasil',
        msg: 'Tahun Ajaran berhasil diperbarui.',
        type: QuickAlertType.success);
    ItemQuickAlert quickAlertFalse = ItemQuickAlert(
        title: 'Gagal',
        msg: 'Tahun Ajaran gagal diperbarui.',
        type: QuickAlertType.error);
    _showModalBottomSheet(
      ref: ref,
      textTitle: 'Edit Tahun Ajaran',
      textButton: 'Ubah',
      onPress: () {
        if (ref.watch(selectDataModelJadwalProvider).tahunAjaran !=
            textTahunAjaran.text) {
          ref
              .read(modelJadwalRepositoryProvider)
              .updateTahunAjaran(
                  widget.idModel!, int.parse(textTahunAjaran.text))
              .then((value) {
            if (value) {
              ref.read(selectDataModelJadwalProvider.notifier).tahunAjaran =
                  textTahunAjaran.text;
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

  void _showModalBottomSheet(
      {required WidgetRef ref,
      required String textTitle,
      required String textButton,
      required onPress}) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return _updateTahunAjaran(
            ref: ref,
            text: textTitle,
            textButton: textButton,
            onPressButton: onPress,
          );
        });
  }

  Widget _updateTahunAjaran(
      {required WidgetRef ref,
      required String text,
      required String textButton,
      required onPressButton}) {
    textTahunAjaran.text = '';
    if (!_inputAktif) {
      _inputTahunAjaran = ref.watch(selectDataModelJadwalProvider).tahunAjaran;
      _inputAktif = true;
    }
    textTahunAjaran.text = _inputTahunAjaran;
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
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4)
                  ],
                  onChanged: (value) {
                    textTahunAjaran.text = value;
                    _inputTahunAjaran = value;
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    labelText: 'Tahun Ajaran',
                    labelStyle: const TextStyle(color: Colors.black87),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
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
                            onPressButton();
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  bool get wantKeepAlive => true;
}
