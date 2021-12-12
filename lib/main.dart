import 'package:copyrightapp/const/svg_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      title: 'Copyright App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Scaffold(
        backgroundColor: const Color(0xFF443FCE),
        body: Stack(
          children: [
            SvgPicture.asset(
              SVGConst.homeScreenBackground,
              alignment: Alignment.bottomCenter,
              // width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
            ),
            Column(
              children: [
                const PageAppBar(),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          CenterIconWidget(
                            backgroundImage: SVGConst.rectangleBlue,
                            centerdImage: SVGConst.camera,
                            title: "Take a Photo",
                          ),
                          SizedBox(width: 20),
                          CenterIconWidget(
                            backgroundImage: SVGConst.rectanglYellow,
                            centerdImage: SVGConst.file,
                            title: "Open Gallery",
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PageAppBar extends StatelessWidget {
  const PageAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 18, right: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Text(
                "Select Opetion",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Select opetion to apply copyright on Image",
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFBAB8F1),
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SvgPicture.asset(
              SVGConst.setting,
              width: 35,
              height: 35,
            ),
          ),
        ],
      ),
    );
  }
}

class CenterIconWidget extends StatelessWidget {
  const CenterIconWidget(
      {Key? key,
      required this.backgroundImage,
      required this.centerdImage,
      required this.title})
      : super(key: key);

  final String backgroundImage;
  final String centerdImage;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration:
              const BoxDecoration(color: Colors.transparent, boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20.0,
              spreadRadius: 5,
              offset: Offset(0, 11),
            ),
          ]),
          child: Stack(
            children: [
              SvgPicture.asset(
                backgroundImage,
                width: 150,
                height: 150,
              ),
              SizedBox(
                width: 150,
                height: 150,
                child: Center(
                  child: SvgPicture.asset(
                    centerdImage,
                    alignment: Alignment.center,
                    height: 62,
                    width: 62,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 23,
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        )
      ],
    );
  }
}
