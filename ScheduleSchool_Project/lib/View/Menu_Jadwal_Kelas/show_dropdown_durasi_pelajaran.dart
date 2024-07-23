import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Provider/provider_menu_jadwal_kelas.dart';

// ignore: must_be_immutable
class ShowDropdownDurasiPelajaran extends ConsumerStatefulWidget {
  List<dynamic> data3Next;
  int? selectDurasiPelajaran;
  ShowDropdownDurasiPelajaran(this.data3Next, this.selectDurasiPelajaran,
      {Key? key})
      : super(key: key);

  @override
  ConsumerState<ShowDropdownDurasiPelajaran> createState() =>
      _ShowDropdownDurasiPelajaranState();
}

class _ShowDropdownDurasiPelajaranState
    extends ConsumerState<ShowDropdownDurasiPelajaran> {
  bool validator = true;

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem> items =
        generateItems(ref, widget.data3Next).toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Text(
            'Durasi Pelajaran : ',
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
              'Select Guru',
              style: TextStyle(fontSize: 12),
            )),
            items: items,
            onSaved: (value) {
              widget.selectDurasiPelajaran = value;
            },
            onChanged: (item) {
              ref.read(selectDataJadwalProvider.notifier).durasiPelajaran =
                  item;
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
            value: widget.selectDurasiPelajaran,
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem> generateItems(WidgetRef ref, List<dynamic> data3Next) {
    List<DropdownMenuItem> items = [];
    for (int i = 0; i < data3Next.length; i++) {
      items.add(DropdownMenuItem(
        value: i + 1,
        child: Center(
            child: Text(
          (i + 1).toString(),
          style: const TextStyle(fontSize: 12),
        )),
      ));
    }
    return items;
  }
}
