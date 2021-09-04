import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/widgets/outer_box_shadow.dart';

class TextBadge extends StatelessWidget {
  const TextBadge({
    Key? key,
    required this.text,
    this.textColor = Colors.white,
    this.backColor = const Color(0xFF4E7FFF),
    this.fontSize = 11,
    this.padding = const EdgeInsets.all(defaultPadding),
    this.fontWeight = FontWeight.w600,
    this.icon,
    this.hasBoxShadow = false,
  }) : super(key: key);

  final Color backColor;
  final Color textColor;
  final String text;
  final double fontSize;
  final EdgeInsets padding;
  final FontWeight fontWeight;
  final Icon? icon;
  final bool hasBoxShadow;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        color: backColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: padding,
      child: Row(
        children: [
          if (icon != null) icon!,
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
