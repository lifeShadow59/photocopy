import 'dart:io';
import 'dart:math';
import 'package:copyrightapp/const/svg_const.dart';
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
  final ImagePicker _picker = ImagePicker();

  bool isLoading = false;

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
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
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
                                  onTap: () async {
                                    await takeAPhoto(context);
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  child: const CenterIconWidget(
                                    backgroundImage: SVGConst.rectangleBlue,
                                    centerdImage: SVGConst.camera,
                                    title: "Take a Photo",
                                  ),
                                ),
                                const SizedBox(width: 20),
                                InkWell(
                                  onTap: () async {
                                    await openGallery(context);
                                  },
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

  Future<void> openGallery(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    setState(() {
      _originalImage = File(image.path);
    });
    developer.log("1");
    List<String> smsString = await getStringForWaterMark();
    if (smsString.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowImage(
          image: _originalImage,
        ),
      ),
    );
  }

  Future<List<String>> getStringForWaterMark() async {
    int itt = 0;
    while (true) {
      if ((_storage.read<String>('text') ?? '') == '' ||
          ((_storage.read<bool>('emailShow') ?? false) &&
              (_storage.read<String>('email') ?? '') == '')) {
        if (itt == 0) {
          itt = itt + 1;
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Setting(),
            ),
          );
        } else {
          return [];
        }
      } else {
        String waterMarkString = '©Copyright ';
        int year = DateTime.now().year;
        return [
          '$waterMarkString $year ${_storage.read<String>('text') ?? ''}',
          _storage.read<String>('email') ?? ''
        ];
      }
    }
  }

  Future<File?> setWaterMark(
    BuildContext s,
    File _originalImage,
    String _waterMarkString,
    String _email,
  ) async {
    ui.Image? originalImage = ui.decodeImage(_originalImage.readAsBytesSync());
    developer.log("2.1");
    // ui.Image? watermarkImage =
    //     ui.decodeImage((_watermarkImage.readAsBytesSync()));
    if (originalImage != null) {
      //* Get Height and width
      ui.Image image = ui.Image(originalImage.width, originalImage.height);
      //* Drow Image
      developer.log("2.2");

      ui.drawImage(image, originalImage);
      developer.log("2.3");

      //*  setString
      debugPrint(
        "originalImage.width => ${originalImage.width}",
      );
      debugPrint(
        "originalImage.height => ${originalImage.height}",
      );
      developer.log("2.4");
      const TextStyle style = TextStyle(fontSize: 48);

      TextPainter _waterMarkStringTextPainter = TextPainter()
        ..text = TextSpan(text: _waterMarkString, style: style)
        ..textDirection = TextDirection.ltr
        ..layout(minWidth: 0, maxWidth: double.infinity);

      TextPainter _emailStringTextPainter = TextPainter()
        ..text = TextSpan(text: _waterMarkString, style: style)
        ..textDirection = TextDirection.ltr
        ..layout(minWidth: 0, maxWidth: double.infinity);
      developer.log("2.5");
      double waterMarkLength =
          max(_waterMarkStringTextPainter.width, _emailStringTextPainter.width);
      developer.log("2.6");

      ui.drawString(
        originalImage,
        ui.arial_48,
        originalImage.width - waterMarkLength.toInt(),
        originalImage.height - 150,
        _waterMarkString,
        color: 0xFF808080,
      );
      developer.log("2.7");

      if (_email != "") {
        ui.drawString(
          originalImage,
          ui.arial_48,
          originalImage.width - waterMarkLength.toInt(),
          originalImage.height - 65,
          _email,
          color: 0xFF808080,
        );
      }
      developer.log("2.8");

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
      developer.log("2.9");

      return watermarkedFile;
    }
  }

  Future<void> takeAPhoto(BuildContext context) async {
    developer.log("1", name: 'get Image');
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) {
      developer.log("2", name: 'image null');
      setState(() {
        isLoading = false;
      });
      return;
    }
    developer.log("2", name: 'Image not null');
    setState(() {
      _originalImage = File(image.path);
    });
    developer.log("3", name: '_original Image set');
    developer.log("4", name: 'get sms String');
    List<String> smsString = await getStringForWaterMark();
    developer.log("5", name: 'get sms String complate');
    if (smsString.isEmpty) {
      developer.log("6", name: 'sms String empty');

      setState(() {
        isLoading = false;
      });
      return;
    }
    developer.log("6", name: 'sms String not empty');
    developer.log("7", name: 'navigation push start');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowImage(
          image: _originalImage,
        ),
      ),
    );
    developer.log("8", name: 'navigation push complate');

    // File? withLogo =
    //     await setWaterMark(context, _originalImage, smsString[0], smsString[1]);
    // if (withLogo != null) {
    //   setState(() {
    //     isLoading = false;
    //   });
    // }

    // developer.log(
    //   image?.path ?? 'No picker Any Immage',
    //   name: 'openGallery Function',
    // );
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
