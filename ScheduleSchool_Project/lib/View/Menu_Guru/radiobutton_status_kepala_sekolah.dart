import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Provider/provider_menu_guru.dart';

class RadioButtonStatusKepalaSekolah extends ConsumerStatefulWidget {
  const RadioButtonStatusKepalaSekolah({Key? key}) : super(key: key);

  @override
  ConsumerState<RadioButtonStatusKepalaSekolah> createState() =>
      _RadioButtonStatusKepalaSekolahState();
}

class _RadioButtonStatusKepalaSekolahState
    extends ConsumerState<RadioButtonStatusKepalaSekolah> {
  String? selectStatusKepalaSekolah;
  @override
  Widget build(BuildContext context) {
    selectStatusKepalaSekolah =
        ref.watch(selectDataGuruProvider).statusKepalaSekolah;
    return Consumer(builder: (context, ref, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio(
              value: 'True',
              groupValue: selectStatusKepalaSekolah,
              onChanged: (value) {
                setSelectedRadio(ref, value!);
              }),
          const Text('Iya'),
          Radio(
              value: 'False',
              groupValue: selectStatusKepalaSekolah,
              onChanged: (value) {
                setSelectedRadio(ref, value!);
              }),
          const Text('Tidak'),
        ],
      );
    });
  }

  void setSelectedRadio(WidgetRef ref, String value) {
    setState(() {
      selectStatusKepalaSekolah = value;
      ref.read(selectDataGuruProvider.notifier).statusKepalaSekolah = value;
    });
  }
}
