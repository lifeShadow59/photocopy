import 'dart:io';

import 'package:copyrightapp/const/svg_const.dart';
import 'package:copyrightapp/pages/home/write_string_in_image.dart';
import 'package:copyrightapp/pages/setting/setting.dart';
import 'package:copyrightapp/pages/show_image/shaow_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as developer;
import 'package:image/image.dart' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late File _originalImage;
  late File _watermarkImage;
  final GetStorage _storage = GetStorage();

  @override
  void initState() {
    super.initState();
  }

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
                        children: <Widget>[
                          InkWell(
                            onTap: takeAPhoto,
                            child: const CenterIconWidget(
                              backgroundImage: SVGConst.rectangleBlue,
                              centerdImage: SVGConst.camera,
                              title: "Take a Photo",
                            ),
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: openGallery,
                            child: const CenterIconWidget(
                              backgroundImage: SVGConst.rectanglYellow,
                              centerdImage: SVGConst.file,
                              title: "Open Gallery",
                            ),
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

  Future<void> openGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _originalImage = File(image.path);
        _watermarkImage = File(image.path);
      });

      File? withLogo =
          await setWaterMark(_originalImage, _watermarkImage, "hii");
      if (withLogo != null) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowImage(
              showPhoto: withLogo,
            ),
          ),
        );
      }
    }
    developer.log(
      image?.path ?? 'No picker Any Immage',
      name: 'openGallery Function',
    );
  }

  Future<String> getStringForWaterMark() async {
    String text = '';
    String email = '';
    while (true) {
      text = _storage.read<String>('text') ?? '';
      email = _storage.read<String>('email') ?? '';
      if (text == '') {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Setting(),
          ),
        );
      } else {
        break;
      }
    }

    String waterMarkString = '©Copyright ';
    int year = DateTime.now().year;
    return 'waterMarkString + $year ';
  }

  Future<File?> setWaterMark(File _originalImage, File _watermarkImage,
      String _waterMarkString) async {
    ui.Image? originalImage = ui.decodeImage(_originalImage.readAsBytesSync());
    ui.Image? watermarkImage =
        ui.decodeImage((_watermarkImage.readAsBytesSync()));
    if (originalImage != null && watermarkImage != null) {
      //* Get Height and width
      ui.Image image = ui.Image(originalImage.width, originalImage.height);
      //* Drow Image
      ui.drawImage(image, watermarkImage);
      //*  setString
      debugPrint(
        "originalImage.width => ${originalImage.width}",
      );
      debugPrint(
        "originalImage.height => ${originalImage.height}",
      );
      ui.drawString(
        originalImage,
        ui.arial_48,
        originalImage.width - 300,
        originalImage.height - 100,
        _waterMarkString,
        color: 0xFF808080,
      );
      // ui.Image s = WriteImageInString.drowS(
      //   originalImage,
      //   ui.arial_48,
      //   originalImage.width - 300,
      //   originalImage.height - 100,
      //   _waterMarkString,
      //   color: 0xFF808080,
      // );
      final fileName = path.basename(_originalImage.path);
      final File watermarkedFile =
          File('${(await getTemporaryDirectory()).path}/$fileName');
      await watermarkedFile.writeAsBytes(ui.encodeJpg(originalImage));
      return watermarkedFile;
    }
  }

  Future<void> takeAPhoto() async {
    final _imagePicker = ImagePicker();
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      debugPrint("Image not null");
      setState(() {
        _originalImage = File(image.path);
        _watermarkImage = File(image.path);
      });

      File? withLogo =
          await setWaterMark(_originalImage, _watermarkImage, "hii");
      if (withLogo != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowImage(
              showPhoto: withLogo,
            ),
          ),
        );
      }
    }
    developer.log(
      image?.path ?? 'No picker Any Immage',
      name: 'openGallery Function',
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
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 45 - 38,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  "Select Option",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Select option to apply copyright on Image",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFBAB8F1),
                    fontWeight: FontWeight.w600,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.clip,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Setting(),
                  ),
                );
              },
              child: SvgPicture.asset(
                SVGConst.setting,
                width: 35,
                height: 35,
              ),
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
