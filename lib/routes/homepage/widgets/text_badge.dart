import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';

class TextBadge extends StatelessWidget {
  const TextBadge({
    Key? key,
    required this.text,
    this.textColor = Colors.white,
    this.backColor = const Color(0xFF4E7FFF),
    this.fontSize = 11,
    this.padding = const EdgeInsets.all(defaultPadding),
    this.fontWeight = FontWeight.w600,
  }) : super(key: key);

  final Color backColor;
  final Color textColor;
  final String text;
  final double fontSize;
  final EdgeInsets padding;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        color: backColor,
      ),
      padding: padding,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
