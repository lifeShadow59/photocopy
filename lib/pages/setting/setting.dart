import 'package:copyrightapp/const/svg_const.dart';
import 'package:copyrightapp/utils/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        ),
      ),
    );
  }
}

class BottomPage extends StatefulWidget {
  const BottomPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  final TextEditingController _defaultTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final FocusNode _defaultFocusNode = FocusNode();
  final FocusNode _emailTextFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GetStorage _storage = GetStorage();
  bool _emailShow = false;
  bool _emailErrorShow = false;
  bool _textErrorShow = false;
  final RegExp emailValidation = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  @override
  void initState() {
    super.initState();
    _defaultTextController.text = _storage.read<String>('text') ?? '';
    _emailTextController.text = _storage.read<String>('email') ?? '';
    _emailShow = _storage.read<bool>('emailShow') ?? false;
  }

  @override
  Widget build(BuildContext context) {
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
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 9,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        elevation: _defaultFocusNode.hasFocus ? 10 : 0,
                        shadowColor: _defaultFocusNode.hasFocus
                            ? Colors.black54
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        child: TextField(
                          controller: _defaultTextController,
                          focusNode: _defaultFocusNode,
                          cursorColor: Colors.black,
                        ),
                      ),
                      _textErrorShow
                          ? const Text(
                              ' Value Can\'t Be Empty',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 35,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Switch(
                            onChanged: (bool value) {
                              setState(() {
                                _emailShow = value;
                                _storage.write('emailShow', value);
                              });
                            },
                            value: _emailShow,
                            activeColor: const Color(0xFF443FCE),
                          )
                        ],
                      ),
                      _emailShow
                          ? Material(
                              elevation: _emailTextFocusNode.hasFocus ? 10 : 0,
                              shadowColor: _emailTextFocusNode.hasFocus
                                  ? Colors.black54
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              child: TextField(
                                controller: _emailTextController,
                                focusNode: _emailTextFocusNode,
                                cursorColor: Colors.black,
                              ),
                            )
                          : const SizedBox(),
                      _emailShow
                          ? _emailErrorShow
                              ? const Text(
                                  ' Your email is Wrong',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                )
                              : const SizedBox()
                          : const SizedBox(),
                      const SizedBox(
                        height: 100,
                      ),
                      ElevatedButtonWidget(
                        title: "Submit",
                        enable: true,
                        onTap: () {
                          bool emailISValid = emailValidation
                                  .hasMatch(_emailTextController.text) &&
                              _emailTextController.text != '';
                          print(emailISValid);
                          if (_defaultTextController.text == '' &&
                              _emailShow &&
                              !emailISValid) {
                            _emailErrorShow = true;
                            _textErrorShow = true;
                            setState(() {});
                            return;
                          } else if (_emailShow && !emailISValid) {
                            _emailErrorShow = true;
                            setState(() {});
                            return;
                          } else if (_defaultTextController.text == '') {
                            _textErrorShow = true;
                            setState(() {});
                            return;
                          }
                          print(
                              "_emailTextController.text  ==> ${_emailTextController.text}");
                          print(
                              "emailValidation.hasMatch(_emailTextController.text) ==> ${emailValidation.hasMatch(_emailTextController.text)} ");

                          if (_emailShow) {
                            _storage.write('email', _emailTextController.text);
                          }
                          _storage.write('text', _defaultTextController.text);
                          _storage.write('emailShow', _emailShow);
                          setState(() {});
                          Navigator.pop(context);
                        },
                      ),
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
      padding: const EdgeInsets.only(top: 50, left: 18),
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
                SVGConst.back,
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
                  fontWeight: FontWeight.w600,
                ),
                softWrap: true,
                overflow: TextOverflow.clip,
              )
            ],
          ),
        ],
      ),
    );
  }
}
