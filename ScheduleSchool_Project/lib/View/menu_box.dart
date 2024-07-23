import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class MenuBox extends StatelessWidget {
  String text;
  String lottie;
  double scale;
  Widget widget;

  MenuBox(
      {super.key,
      required this.text,
      required this.lottie,
      required this.scale,
      required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.6 * scale,
      height: MediaQuery.of(context).size.height * 0.55 * scale,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          )
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: <Widget>[
          const Positioned.fill(
            child: Image(
              image: AssetImage("images/Background2.jpg"),
              fit: BoxFit.fill,
              repeat: ImageRepeat.repeat,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: Colors.black38,
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => widget));
              },
              child: Column(
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          text,
                          style: TextStyle(
                              fontSize: 20 * scale,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  Expanded(
                    flex: 2,
                    child: LottieBuilder.asset(
                      lottie,
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
