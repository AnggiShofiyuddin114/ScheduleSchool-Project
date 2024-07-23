import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Provider/provider_menu_model_jadwal.dart';

// ignore: must_be_immutable
class ShowDropdownJenisKegiatan extends ConsumerStatefulWidget {
  List<dynamic> dataJenisKegiatan;
  ShowDropdownJenisKegiatan(this.dataJenisKegiatan, {Key? key})
      : super(key: key);

  @override
  ConsumerState<ShowDropdownJenisKegiatan> createState() =>
      _ShowDropdownJenisKegiatanState();
}

class _ShowDropdownJenisKegiatanState
    extends ConsumerState<ShowDropdownJenisKegiatan>
    with AutomaticKeepAliveClientMixin {
  bool validator = true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<DropdownMenuItem> items =
        generateItems(ref, widget.dataJenisKegiatan).toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Text(
            'Jenis Kegiatan : ',
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
            hint: const Center(
                child: Text(
              'Select Jenis Kegiatan',
              style: TextStyle(fontSize: 12),
            )),
            items: items,
            onSaved: (value) {
              ref
                  .read(selectEditDataModelJadwalProvider.notifier)
                  .selectJenisKegiatan = value;
            },
            onChanged: (item) {
              setState(() {
                ref
                    .read(selectEditDataModelJadwalProvider.notifier)
                    .selectJenisKegiatan = item;
              });
            },
            buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 12),
                height: 40,
                width: 160),
            menuItemStyleData: const MenuItemStyleData(height: 30),
            validator: (value) {
              setState(() {
                validator = true;
              });
              return null;
            },
            value: ref
                .watch(selectEditDataModelJadwalProvider)
                .selectJenisKegiatan,
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem> generateItems(
      WidgetRef ref, List<dynamic> jenisKegiatan) {
    List<DropdownMenuItem> items = [];
    for (var item in jenisKegiatan) {
      items.add(DropdownMenuItem(
        value: item,
        child: Center(
            child: Text(
          item.namaJenisKegiatan!,
          style: const TextStyle(fontSize: 12),
        )),
      ));
    }
    return items;
  }

  @override
  bool get wantKeepAlive => true;
}
