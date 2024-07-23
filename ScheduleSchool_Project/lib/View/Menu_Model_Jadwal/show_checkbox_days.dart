import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Provider/provider_menu_model_jadwal.dart';
import 'package:flutter_app2/View/Menu_Model_Jadwal/item_hari.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowCheckBoxDays extends ConsumerStatefulWidget {
  const ShowCheckBoxDays({Key? key}) : super(key: key);

  @override
  ConsumerState<ShowCheckBoxDays> createState() => _ShowCheckBoxDaysState();
}

class _ShowCheckBoxDaysState extends ConsumerState<ShowCheckBoxDays> {
  late List<ItemHari> hari;
  List<String> selectedItems = [];
  bool validator = true;
  @override
  Widget build(BuildContext context) {
    selectedItems = ref.watch(selectDataModelJadwalProvider).selectHariLibur;
    hari = ItemDays();
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: validator ? 0 : 24),
          child: const Text(
            ' Hari Libur : ',
            style: TextStyle(fontSize: 11),
          ),
        ),
        DropdownButtonHideUnderline(
            child: SizedBox(
          width: MediaQuery.of(context).size.width - 175,
          child: DropdownButtonFormField2<String>(
            validator: (value) {
              if (value == null || selectedItems.join(', ') == '') {
                setState(() {
                  validator = false;
                });
                return 'Tolong diisi';
              } else if (selectedItems.length == hari.length) {
                return 'Hari libur maksimal 6';
              }
              setState(() {
                validator = true;
              });
              return null;
            },
            decoration: InputDecoration(
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              labelStyle: const TextStyle(color: Colors.black87, fontSize: 11),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            ),
            isExpanded: true,
            hint: const Center(
                child: Text(
              'Select Item',
              style: TextStyle(color: Colors.black87, fontSize: 11),
              maxLines: 1,
            )),
            items: hari.map((item) {
              return DropdownMenuItem(
                  value: item.hari,
                  enabled: true,
                  child: StatefulBuilder(builder: (context, menuSetState) {
                    final isSelected = selectedItems.contains(item.hari);
                    return InkWell(
                      onTap: () {
                        setState(() {
                          isSelected
                              ? selectedItems.remove(item.hari)
                              : selectedItems.add(item.hari);
                          ref
                              .read(selectDataModelJadwalProvider.notifier)
                              .setStatusHariLibur(item.index,
                                  (!isSelected).toString().toUpperCase());
                        });
                        menuSetState(() {});
                      },
                      child: Container(
                        height: 20,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            if (isSelected)
                              const Icon(Icons.check_box_outlined)
                            else
                              const Icon(Icons.check_box_outline_blank),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Text(
                              item.hari,
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 11),
                            )),
                          ],
                        ),
                      ),
                    );
                  }));
            }).toList(),
            value: selectedItems.isEmpty ? null : selectedItems.last,
            onChanged: (value) {},
            selectedItemBuilder: (context) {
              return hari.map((item) {
                return Container(
                  alignment: Alignment.center,
                  child: Center(
                    child: Text(
                      selectedItems.join(', '),
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 11,
                          overflow: TextOverflow.ellipsis),
                      maxLines: 1,
                    ),
                  ),
                );
              }).toList();
            },
            buttonStyleData: const ButtonStyleData(
              height: 20,
              width: 140,
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 30,
              padding: EdgeInsets.zero,
            ),
          ),
        )),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  List<ItemHari> ItemDays() {
    List<ItemHari> hasil = <ItemHari>[];
    final List<String> hari = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    for (int i = 0; i < hari.length; i++) {
      ItemHari itemHari = ItemHari(index: i, hari: hari[i]);
      hasil.add(itemHari);
    }
    return hasil;
  }
}
