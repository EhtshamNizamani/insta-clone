// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Followers extends StatelessWidget {
  final Function()? function;
  final Color borderColor;
  final Color textColor;
  final Color backgroudColor;
  final String text;
  const Followers({
    Key? key,
    this.function,
    required this.borderColor,
    required this.textColor,
    required this.backgroudColor,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        alignment: Alignment.center,
        width: 250,
        height: 28,
        decoration: BoxDecoration(
            color: backgroudColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: borderColor)),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
