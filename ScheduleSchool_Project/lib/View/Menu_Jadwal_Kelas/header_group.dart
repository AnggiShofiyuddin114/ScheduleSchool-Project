import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Provider/provider_menu_jadwal_kelas.dart';

class HeaderGroup extends ConsumerStatefulWidget {
  const HeaderGroup({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HeaderGroupState createState() => _HeaderGroupState();
}

class _HeaderGroupState extends ConsumerState<HeaderGroup> {
  String? text = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      text = ref.watch(currentGroupsStreamProvider).value;
      text ??= ref.watch(currentGroupsProvider).currentGroup;
      return Container(
        color: Colors.grey[50],
        height: 45,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text!,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      );
    });
  }
}
