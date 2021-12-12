import 'package:copyrightapp/const/svg_const.dart';
import 'package:copyrightapp/utils/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF443FCE),
        extendBody: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            PageAppBar(),
            SizedBox(
              height: 40,
            ),
            BottomPage()
          ],
        ));
  }
}

class BottomPage extends StatelessWidget {
  const BottomPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _defaultTextController =
        TextEditingController();
    final TextEditingController _emailTextController = TextEditingController();
    final FocusNode _defaultFocusNode = FocusNode();
    final FocusNode _emailTextFocusNode = FocusNode();
    final GlobalKey<FormState> _formKey = GlobalKey();
    return Expanded(
      flex: 1,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          color: Color(0xFFF2F4F5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Edit Default Text",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        elevation: _defaultFocusNode.hasFocus ? 10 : 0,
                        shadowColor: _defaultFocusNode.hasFocus
                            ? Colors.red
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        child: TextField(
                          controller: _defaultTextController,
                          focusNode: _defaultFocusNode,
                          cursorColor: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      const Text(
                        "Email",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Material(
                        elevation: _emailTextFocusNode.hasFocus ? 10 : 0,
                        shadowColor: _emailTextFocusNode.hasFocus
                            ? Colors.red
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        child: TextField(
                          controller: _emailTextController,
                          focusNode: _emailTextFocusNode,
                          cursorColor: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      ElevatedButtonWidget(
                          title: "Submit", enable: true, onTap: () {})
                    ],
                  ),
                )
                // Spacer()
              ],
            ),
          ),
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 20),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                SVGConst.setting,
                width: 35,
                height: 35,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Text(
                "Text Setting",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Edit copyright text to apply on your image",
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFBAB8F1),
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ],
      ),
    );
  }
}
