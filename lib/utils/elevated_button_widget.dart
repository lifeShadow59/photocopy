import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String title;
  final bool enable;
  final void Function() onTap;
  final Color disabledColor;
  const ElevatedButtonWidget({
    Key? key,
    required this.title,
    required this.enable,
    required this.onTap,
    this.disabledColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = enable ? const Color(0xFF443FCE) : Colors.grey;
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Colors.transparent),
          ),
        ),
        elevation: MaterialStateProperty.all<double>(10),
        shadowColor: MaterialStateProperty.all<Color>(
          color.withOpacity(0.7),
        ),
        animationDuration: Duration(milliseconds: enable ? 500 : 0),
        backgroundColor: MaterialStateProperty.all<Color>(
          color,
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
      onPressed: onTap,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
