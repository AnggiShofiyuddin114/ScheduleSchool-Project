import 'package:flutter/material.dart';
import 'package:flutter_app2/View/Menu_Jadwal_Kelas/jadwal_per_kelas.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Provider/provider_menu_jadwal_kelas.dart';

class AturJadwalPerkelasPage extends ConsumerStatefulWidget {
  final int? idModel;
  final String? namaModel;
  final int? jumlahJamPerhari;
  const AturJadwalPerkelasPage(
      {Key? key, this.idModel, this.namaModel, this.jumlahJamPerhari})
      : super(key: key);

  @override
  ConsumerState<AturJadwalPerkelasPage> createState() =>
      _AturJadwalPerkelasPageState();
}

class _AturJadwalPerkelasPageState
    extends ConsumerState<AturJadwalPerkelasPage> {
  List _elements = [];
  List<ScrollController> _lscrollController =
      List.generate(6, (index) => ScrollController());

  @override
  void initState() {
    super.initState();
    ref.read(currentGroupsProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
        onWillPop: () async {
          _lscrollController = List.generate(6, (index) => ScrollController());
          Navigator.of(context).pop();
          return false;
        },
        child: ref.watch(jadwalRepositoryFutureProvider(widget.idModel)).when(
              data: (data) {
                _elements = data[0];
                List<List<dynamic>> allDataMapelKelas = data[2];
                List<Map<String, Object>> allDataGuru = data[3];
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Jadwal Kelas (${widget.namaModel})'),
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                  body: DefaultTabController(
                    length: 6,
                    child: Column(
                      children: [
                        const TabBar(tabs: [
                          Tab(
                            text: '  1  ',
                          ),
                          Tab(
                            text: '  2  ',
                          ),
                          Tab(
                            text: '  3  ',
                          ),
                          Tab(
                            text: '  4  ',
                          ),
                          Tab(
                            text: '  5  ',
                          ),
                          Tab(
                            text: '  6  ',
                          ),
                        ]),
                        Expanded(
                            child: TabBarView(
                          children: List.generate(
                              6,
                              (index) => JadwalPerKelas(
                                  context,
                                  widget.idModel!,
                                  widget.jumlahJamPerhari!,
                                  data[1],
                                  _elements
                                      .where(
                                          (item) => item['id_kelas'] == index)
                                      .toList(),
                                  allDataMapelKelas[index],
                                  allDataGuru,
                                  index,
                                  _elements,
                                  _lscrollController)),
                        )),
                      ],
                    ),
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
            ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
