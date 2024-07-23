import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app2/View/Menu_Guru/guru_page.dart';
import 'package:flutter_app2/View/Menu_Jadwal_Kelas/jadwal_kelas_page.dart';
import 'package:flutter_app2/View/Menu_Model_Jadwal/model_jadwal_page.dart';
import 'package:flutter_app2/View/Menu_Pelajaran/kelas_page.dart';
import 'package:flutter_app2/View/menu_box.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double? currentPageValue = 0;
  PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.8);

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        currentPageValue = pageController.page;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> lottie = [
      'assets/lottie1.json',
      'assets/lottie2.json',
      'assets/lottie3.json',
      'assets/lottie4.json'
    ];
    List<Widget> widget = [
      ModelJadwalPage(),
      JadwalKelasPage(),
      GuruPage(),
      KelasPage()
    ];
    List<String> texts = [
      'Model Jadwal',
      'Jadwal Kelas',
      'Guru',
      'Mata Pelajaran'
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Stack(
        children: <Widget>[
          const Positioned.fill(
            child: Image(
              image: AssetImage("images/Background5.jpg"),
              fit: BoxFit.contain,
              repeat: ImageRepeat.repeat,
            ),
          ),
          PageView.builder(
              controller: pageController,
              itemCount: widget.length,
              itemBuilder: (context, index) {
                double difference = index - currentPageValue!;
                if (difference < 0) {
                  difference *= -1;
                }
                difference = min(1, difference);
                return Center(
                  child: MenuBox(
                    text: texts[index],
                    lottie: lottie[index],
                    scale: 1 - (difference * 0.5),
                    widget: widget[index],
                  ),
                );
              }),
        ],
      )),
    );
  }
}
