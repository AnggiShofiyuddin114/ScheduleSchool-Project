import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Model/Repository/guru_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Model/Repository/kode_guru_repository.dart';
import '../../Provider/provider_menu_jadwal_kelas.dart';

// ignore: must_be_immutable
class ShowDropdownGuru extends ConsumerStatefulWidget {
  List<dynamic> dataGuru;
  Guru? selectGuru;
  KodeGuru? selectKodeGuru;
  KodeGuru? currentselectKodeGuru;

  ShowDropdownGuru(this.dataGuru, this.selectGuru, this.selectKodeGuru,
      this.currentselectKodeGuru,
      {Key? key})
      : super(key: key);

  @override
  ConsumerState<ShowDropdownGuru> createState() => _ShowDropdownGuruState();
}

class _ShowDropdownGuruState extends ConsumerState<ShowDropdownGuru> {
  bool validator = true;
  // ignore: avoid_init_to_null
  int? index = null;

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem> items = generateItems(ref, null, widget.dataGuru,
            widget.selectGuru, widget.selectKodeGuru)
        .toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Text(
            'Guru : ',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 14),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonFormField2(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              contentPadding: EdgeInsets.zero,
            ),
            isExpanded: true,
            hint: Center(
                child: Text(
              widget.dataGuru.isNotEmpty ? 'Select Guru' : 'Kosong',
              style: const TextStyle(fontSize: 12),
            )),
            items: items,
            onSaved: (value) {
              index = value;
              widget.selectGuru = widget.dataGuru[value]['guru'];
              widget.selectKodeGuru = widget.dataGuru[value]['kode_guru'];
            },
            onChanged: (item) {
              setState(() {
                index = item;
                widget.selectGuru = widget.dataGuru[item]['guru'];
                widget.selectKodeGuru = widget.dataGuru[item]['kode_guru'];
                ref.read(selectDataJadwalProvider.notifier).guru =
                    widget.dataGuru[item]['guru'];
                ref.read(selectDataJadwalProvider.notifier).kodeGuru =
                    widget.dataGuru[item]['kode_guru'];
              });
            },
            buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 12),
                height: 40,
                width: 160),
            menuItemStyleData: const MenuItemStyleData(height: 30),
            validator: (value) {
              if (value == null) {
                setState(() {
                  validator = false;
                });
                return 'Tolong diisi';
              }
              setState(() {
                validator = true;
              });
              return null;
            },
            value: widget.selectGuru!.idGuru == null ? null : index,
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem> generateItems(WidgetRef ref, int? index,
      List<dynamic> guru, Guru? selectGuru, KodeGuru? selectKodeGuru) {
    List<DropdownMenuItem> items = [];
    int i = 0;
    for (var item in guru) {
      items.add(DropdownMenuItem(
        value: i,
        // ignore: sort_child_properties_last
        child: Center(
            child: Text(
          '(${item['kode_guru'].kodeGuru!}) ${item['guru'].namaGuru!}',
          style: const TextStyle(fontSize: 12, color: Colors.black),
        )),
      ));
      i += 1;
    }
    widget.selectGuru = selectGuru;
    widget.selectKodeGuru = selectKodeGuru;
    int indexSelectGuru = guru.indexWhere((element) =>
        element['kode_guru'].idKodeGuru == selectKodeGuru!.idKodeGuru);
    this.index = indexSelectGuru != -1 ? indexSelectGuru : null;
    ref.read(selectDataJadwalProvider.notifier).guru = widget.selectGuru;
    ref.read(selectDataJadwalProvider.notifier).kodeGuru =
        widget.selectKodeGuru;
    return items;
  }
}
