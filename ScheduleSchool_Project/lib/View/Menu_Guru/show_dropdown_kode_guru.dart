import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Model/Repository/kode_guru_repository.dart';
import '../../Provider/provider_menu_guru.dart';

// ignore: must_be_immutable
class ShowDropdownKodeGuru extends ConsumerStatefulWidget {
  List<KodeGuru> dataKodeGuru;
  KodeGuru selectKodeGuru;

  ShowDropdownKodeGuru(this.dataKodeGuru, this.selectKodeGuru, {Key? key})
      : super(key: key);

  @override
  ConsumerState<ShowDropdownKodeGuru> createState() =>
      _ShowDropdownKodeGuruState();
}

class _ShowDropdownKodeGuruState extends ConsumerState<ShowDropdownKodeGuru> {
  bool validator = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: validator ? 0 : 24),
            child: const Text(
              'Kode Guru : ',
              style: TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 188 - 8,
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
                'Select Kode Guru',
                style: TextStyle(fontSize: 12),
              )),
              items: generateItems(ref, widget.dataKodeGuru).toList(),
              onSaved: (value) {
                widget.selectKodeGuru = value;
              },
              onChanged: (item) {
                setState(() {
                  widget.selectKodeGuru = item!;
                  ref.read(selectDataGuruProvider.notifier).selectKodeGuru =
                      item;
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
              value:
                  ref.watch(selectDataGuruProvider).selectKodeGuru.kodeGuru ==
                          ""
                      ? null
                      : ref.watch(selectDataGuruProvider).selectKodeGuru,
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem> generateItems(WidgetRef ref, List<KodeGuru> kodeGuru) {
    List<DropdownMenuItem> items = [];
    for (var item in kodeGuru) {
      items.add(DropdownMenuItem(
        value: item,
        child: Center(
            child: Text(
          item.kodeGuru!,
          style: const TextStyle(fontSize: 12),
        )),
      ));
    }
    widget.selectKodeGuru = kodeGuru[0];
    return items;
  }
}
