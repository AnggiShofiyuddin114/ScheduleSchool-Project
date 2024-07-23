import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Model/Repository/mapel_repository.dart';
import '../../Provider/provider_menu_jadwal_kelas.dart';

// ignore: must_be_immutable
class ShowDropdownMapelKelas extends ConsumerStatefulWidget {
  List<dynamic> dataMapelKelas;
  Mapel? selectMapelKelas;
  ShowDropdownMapelKelas(this.dataMapelKelas, this.selectMapelKelas, {Key? key})
      : super(key: key);

  @override
  ConsumerState<ShowDropdownMapelKelas> createState() =>
      _ShowDropdownMapelKelasState();
}

class _ShowDropdownMapelKelasState
    extends ConsumerState<ShowDropdownMapelKelas> {
  bool validator = true;
  // ignore: avoid_init_to_null
  int? index = null;

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem> items =
        generateItems(ref, widget.dataMapelKelas, widget.selectMapelKelas)
            .toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Text(
            'Mapel : ',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 14),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: DropdownButtonFormField2(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              contentPadding: EdgeInsets.zero,
            ),
            isExpanded: true,
            hint: Center(
                child: Text(
              widget.dataMapelKelas.isNotEmpty ? 'Select Mapel' : 'Kosong',
              style: const TextStyle(fontSize: 12),
            )),
            items: items,
            onSaved: (value) {
              widget.selectMapelKelas = widget.dataMapelKelas[value];
              ref.read(selectDataJadwalProvider.notifier).mapelKelas =
                  widget.dataMapelKelas[value];
            },
            onChanged: (item) {
              setState(() {
                index = item;
                widget.selectMapelKelas = widget.dataMapelKelas[item];
                ref.read(selectDataJadwalProvider.notifier).mapelKelas =
                    widget.dataMapelKelas[item];
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
            value: widget.selectMapelKelas!.idMapel == null ? null : index,
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem> generateItems(
      WidgetRef ref, List<dynamic> mapelKelas, Mapel? selectMapelKelas) {
    List<DropdownMenuItem> items = [];
    int i = 0;
    for (var item in mapelKelas) {
      items.add(DropdownMenuItem(
        value: i,
        child: Center(
            child: Text(
          item.namaMapel!,
          style: const TextStyle(fontSize: 12),
        )),
      ));
      i += 1;
    }
    widget.selectMapelKelas = selectMapelKelas;
    int indexSelectMapel = mapelKelas
        .indexWhere((element) => element.idMapel == selectMapelKelas!.idMapel);
    index = indexSelectMapel != -1 ? indexSelectMapel : null;
    widget.selectMapelKelas!.idMapel == null ? null : widget.selectMapelKelas;
    ref.read(selectDataJadwalProvider.notifier).mapelKelas =
        widget.selectMapelKelas;
    return items;
  }
}
