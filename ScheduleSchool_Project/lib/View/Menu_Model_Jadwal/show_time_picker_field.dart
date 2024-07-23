import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Provider/provider_menu_model_jadwal.dart';

class ShowTimePickerField extends ConsumerStatefulWidget {
  const ShowTimePickerField({Key? key}) : super(key: key);

  @override
  ConsumerState<ShowTimePickerField> createState() =>
      _ShowTimePickerFieldState();
}

class _ShowTimePickerFieldState extends ConsumerState<ShowTimePickerField> {
  TextEditingController textWaktuMulai = TextEditingController();
  bool validator = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            'Waktu Mulai: ',
            style: TextStyle(fontSize: 11),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 156,
              child: TextFormField(
                style: const TextStyle(fontSize: 11),
                readOnly: true,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                ),
                controller: textWaktuMulai,
                validator: (value) {
                  if (value!.isEmpty) {
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
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: validator ? 0 : 24, left: 8.0),
              child: IconButton(
                  onPressed: () {
                    _selectTime();
                  },
                  icon: const Icon(Icons.access_time)),
            ),
          ],
        )
      ],
    );
  }

  void _selectTime() async {
    List<String> parts =
        ref.watch(selectDataModelJadwalProvider).waktuMulai.split(':');
    TimeOfDay time =
        TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    final TimeOfDay? newTime =
        await showTimePicker(context: context, initialTime: time);
    if (newTime != null) {
      setState(() {
        ref.read(selectTimeProvider.notifier).state = newTime;
        time = newTime;
        textWaktuMulai.text = newTime.format(context);
        ref.watch(selectDataModelJadwalProvider).waktuMulai =
            newTime.format(context);
      });
    }
  }
}
