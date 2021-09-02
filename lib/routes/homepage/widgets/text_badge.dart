import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';

class TextBadge extends StatelessWidget {
  const TextBadge({
    Key? key,
    required this.text,
    this.textColor = Colors.white,
    this.backColor = const Color(0xFF4E7FFF),
  }) : super(key: key);

  final Color backColor;
  final Color textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        color: backColor,
      ),
      padding: const EdgeInsets.all(defaultPadding),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}
