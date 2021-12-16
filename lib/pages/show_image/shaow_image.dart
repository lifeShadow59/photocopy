import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as uiImage;
import 'package:copyrightapp/const/svg_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:developer' as developer;
import 'package:image/image.dart' as ui;
import 'package:path_provider/path_provider.dart';

class ShowImage extends StatefulWidget {
  const ShowImage({
    Key? key,
    required this.image,

    //  required this.photoWidth, required this.photoHeight,
  }) : super(key: key);
  final File image;
  // final double photoWidth;
  // final double photoHeight;
  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  final GlobalKey _key = GlobalKey();
  ui.Image? decodeImage;
  File? waterMarkImage;
  int waterFont = 0;
  int imageWidth = 0;

  @override
  void initState() {
    developer.log("1.1", name: 'init State run');

    // WidgetsBinding.instance?.addPostFrameCallback(_afterLayout);
    developer.log("1.2", name: 'Going file to image');

    _fileToImage(widget.image);
    developer.log("1.3", name: 'file to image complate');

    super.initState();
  }

  void _fileToImage(File image) {
    developer.log("1.2.1", name: ' file to image start');
    decodeImage = ui.decodeImage(image.readAsBytesSync());
    developer.log("1.2.2", name: ' file to image complate');
    developer.log("${decodeImage?.width} ", name: 'image width ');
    imageWidth = decodeImage?.width ?? 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? response = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Are you sure you want to exit? '),
              actions: <Widget>[
                TextButton(
                  child: const Text('YES'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                TextButton(
                  child: const Text('NO'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        );
        return Future.value(response);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF443FCE),
          body: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height - 200),
                      child: Image.file(
                        widget.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 0,
                      child: RepaintBoundary(
                        key: _key,
                        child: WaterMarkWidget(
                          imageWidth: imageWidth,
                          devicePixelRatio:
                              MediaQuery.of(context).devicePixelRatio,
                        ),
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: const Color(0xFF7773E9),
                  ),
                  width: double.maxFinite,
                  height: 55,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: shareFile,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              SVGConst.share,
                              width: 16,
                              height: 16,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Share",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 7),
                        width: (MediaQuery.of(context).size.width - 80) / 3,
                        height: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.white,
                        ),
                        child: InkWell(
                          onTap: () async {
                            await saveFile(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset(
                                SVGConst.save,
                                width: 15,
                                height: 15,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Save",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              SVGConst.sync,
                              width: 16,
                              height: 16,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Reset",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> shareFile() async {
    // print(widget.image.path);

    // print(photo.uri);
    // final fileName = basename(photo.path);
    // int nowYear = DateTime.now().year;
    // List<String> finalFileName = fileName.split('.');
    // finalFileName[0] + '(©Copyright$nowYear)';
    // print(fileName);
    await Share.shareFiles([widget.image.path], text: 'Great picture');
  }

  Future<void> saveFile(BuildContext context) async {
    developer.log("1", name: 'save file function run');
    developer.log("2", name: 'widget To Image run');

    await widgetToImage(context);
    developer.log("3", name: 'widget To Image end');

    if (waterMarkImage == null) {
      developer.log("4", name: 'waterMarkImage null');
      return;
    }
    developer.log("4", name: 'waterMarkImage not null');
    developer.log("5", name: 'go meargeImage');

    ui.Image meargeImages = meargeImage(context);

    developer.log("6", name: 'return meargeImage');
    developer.log("7  ${meargeImages.getBytes().length}",
        name: 'save image meargeImage');

    //! For Save
    // Uint8List imageBytes = meargeImages.getBytes();
    final fileName = basename(widget.image.path);

    final File _watermarkedFile =
        File('${(await getTemporaryDirectory()).path}/$fileName');
    await _watermarkedFile.writeAsBytes(ui.encodeJpg(meargeImages));

    int nowYear = DateTime.now().year;
    List<String> finalFileNameList = fileName.split('.');
    finalFileNameList[0] + '(©Copyright$nowYear).$finalFileNameList[1]';
    String finalFileName =
        '$fileName${finalFileNameList[0]}(©Copyright$nowYear).${finalFileNameList[1]}';
    await ImageGallerySaver.saveImage(
      await _watermarkedFile.readAsBytes(),
      quality: 100,
      name: finalFileName,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo Save in Image Folder..'),
      ),
    );
    debugPrint(widget.image.path);
  }

  ui.Image meargeImage(BuildContext context) {
    developer.log("5.1", name: 'meargeImage start');
    //* Water mark image file formate to image
    ui.Image? _waterMarkImage =
        ui.decodeImage(waterMarkImage!.readAsBytesSync());

    final ui.Image mergedImage =
        ui.Image(decodeImage!.width, decodeImage!.height);
    developer.log("5.2", name: 'meargeImage create image');

    developer.log("5.3", name: 'meargeImage copy image start');

    ui.copyInto(mergedImage, decodeImage!);
    developer.log("5.4", name: 'meargeImage copy image end');

    int imageFinalWidth = (decodeImage!.width * 40) ~/
        (100 * MediaQuery.of(context).devicePixelRatio);
    developer.log("5.5", name: 'image Final Width => $imageFinalWidth');
    developer.log("5.6", name: 'meargeImage copy logo start ');

    ui.copyInto(
      mergedImage, _waterMarkImage!, blend: true,
      // dstX: imageFinalWidth,
      // dstY: mergedImage.height - waterMarkImage!.height - 10,
    );
    developer.log("5.7", name: 'meargeImage copy logo end ');

    return mergedImage;
  }

  Future<void> widgetToImage(BuildContext context) async {
    developer.log("2.1", name: 'widget To Image method start');
    developer.log("2.2", name: ' widget as a boundary get');

    RenderRepaintBoundary? boundary =
        _key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    developer.log("2.3", name: ' widget as a boundary end');

    uiImage.Image? _waterMarkImage = await boundary?.toImage(
        pixelRatio: (MediaQuery.of(context).devicePixelRatio * 3.4));
    developer.log("2.4", name: ' widget as a boundary create image');
    final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData? byteData =
        await _waterMarkImage?.toByteData(format: uiImage.ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();
    waterMarkImage = File('$directory/photo.png');
    await waterMarkImage?.writeAsBytes(pngBytes!);
    setState(() {});
    developer.log("2.5", name: ' widget as a boundary set state complate ');
  }
}

class WaterMarkWidget extends StatefulWidget {
  const WaterMarkWidget({
    Key? key,
    required this.imageWidth,
    required this.devicePixelRatio,
  }) : super(key: key);
  final int imageWidth;
  final double devicePixelRatio;

  @override
  State<WaterMarkWidget> createState() => _WaterMarkWidgetState();
}

class _WaterMarkWidgetState extends State<WaterMarkWidget> {
  final GetStorage _storage = GetStorage();
  final GlobalKey _gkey = GlobalKey();

  String name = '';
  String email = '';
  int waterFont = 1;

  @override
  void initState() {
    developer.log("1", name: ' Water Mark Widget run inint state');
    developer.log("2", name: ' Water Mark Widget get String ');

    _getString();
    developer.log("3", name: ' Water Mark Widget get string end');
    developer.log("4", name: ' Water Mark Widget run addPostFrameCallback');

    WidgetsBinding.instance?.addPostFrameCallback(_afterLayout);
    developer.log("4", name: ' Water Mark Widget end addPostFrameCallback');
    developer.log("5", name: ' Water Mark Widget end inint state');

    super.initState();
  }

  Future<void> _getRenderOffsets() async {
    int imageFinalWidth =
        ((widget.imageWidth * 100) / uiImage.window.devicePixelRatio) ~/ (100);
    developer.log(" $imageFinalWidth", name: 'imageFinalWidth');
    developer.log(" ${uiImage.window.devicePixelRatio}",
        name: 'devicePixelRatio');

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      final RenderRepaintBoundary? renderBoxWidget =
          _gkey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (renderBoxWidget != null) {
        uiImage.Image? i = await renderBoxWidget.toImage();
        developer.log("${i.width}", name: 'width');
        developer.log("${i.width * uiImage.window.devicePixelRatio}",
            name: 'width * devicePixelRatio');

        debugPrint('${i.width}');
        int w = i.width;
        if (w < imageFinalWidth) {
          setState(() {
            waterFont = waterFont + 1;
          });

          _getRenderOffsets();
        } else {
          return;
        }
      } else {
        return;
      }
    });
  }

  void _afterLayout(_) async {
    await _getRenderOffsets();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _gkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: waterFont.toDouble(),
              color: Colors.white,
            ),
          ),
          email != ''
              ? Text(
                  email,
                  style: TextStyle(
                    fontSize: waterFont.toDouble(),
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  List<String> _getStringForWaterMark() {
    String waterMarkString = '©Copyright ';
    int year = DateTime.now().year;
    return [
      '$waterMarkString $year ${_storage.read<String>('text') ?? ''}',
      _storage.read<String>('email') ?? ''
    ];
  }

  void _getString() {
    List<String> s = _getStringForWaterMark();
    name = s[0];
    email = s[1];
    setState(() {});
  }
}
