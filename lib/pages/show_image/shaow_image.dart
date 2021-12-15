import 'dart:io';

import 'package:copyrightapp/const/svg_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';

class ShowImage extends StatelessWidget {
  const ShowImage({Key? key, required this.showPhoto}) : super(key: key);
  final File showPhoto;
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
    print(showPhoto.path);

    // print(showPhoto.uri);
    // final fileName = basename(showPhoto.path);
    // int nowYear = DateTime.now().year;
    // List<String> finalFileName = fileName.split('.');
    // finalFileName[0] + '(©Copyright$nowYear)';
    // print(fileName);
    await Share.shareFiles([showPhoto.path], text: 'Great picture');
  }

  Future<void> saveFile(BuildContext context) async {
    final fileName = basename(showPhoto.path);
    int nowYear = DateTime.now().year;
    List<String> finalFileNameList = fileName.split('.');
    finalFileNameList[0] + '(©Copyright$nowYear).$finalFileNameList[1]';
    String finalFileName =
        '$fileName${finalFileNameList[0]}(©Copyright$nowYear).${finalFileNameList[1]}';
    await ImageGallerySaver.saveImage(await showPhoto.readAsBytes(),
        quality: 100, name: finalFileName);
    // byteData.buffer.asUint8List());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo Save in Image Folder..'),
      ),
    );
    debugPrint(showPhoto.path);
    // showPhoto.
  }
}
