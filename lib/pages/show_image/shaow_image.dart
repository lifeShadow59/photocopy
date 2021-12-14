import 'dart:io';

import 'package:copyrightapp/const/svg_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';

class ShowImage extends StatelessWidget {
  const ShowImage({Key? key, required this.showPhoto}) : super(key: key);
  final File showPhoto;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF443FCE),
        body: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height - 200),
                // height: MediaQuery.of(context).size.height - 240,
                // color: Colors.white,
                child: Image.file(
                  showPhoto,
                  fit: BoxFit.contain,
                ),
              ),
              const Spacer(),
              // const SizedBox(
              //   height: 35,
              // ),
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
                        onTap: saveFile,
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
                    Row(
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
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> shareFile() async {
    print(showPhoto.path);
    print(showPhoto.uri);
    final fileName = basename(showPhoto.path);
    print(fileName);
    await Share.shareFiles([showPhoto.path], text: 'Great picture');
  }

  Future<void> saveFile() async {
    late String path;
    await getApplicationDocumentsDirectory().then((value) => path = value.path);
    debugPrint(path);
    final fileName = basename(showPhoto.path);
    await showPhoto.copy('$path/$fileName');
    await ImageGallerySaver.saveImage(await showPhoto.readAsBytes(),
        quality: 100, name: fileName);
    // byteData.buffer.asUint8List());
    debugPrint(showPhoto.path);
    // showPhoto.
  }
}
