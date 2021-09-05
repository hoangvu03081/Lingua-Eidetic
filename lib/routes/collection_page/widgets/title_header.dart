import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';

class TitleHeader extends StatelessWidget {
  const TitleHeader({
    Key? key,
    required this.title,
    this.backColor = const Color(0xFF8FA6FA),
    this.hasDivider = true,
  }) : super(key: key);
  final String title;
  final Color backColor;
  final bool hasDivider;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        if (hasDivider)
          Positioned.fill(
            left: size.width / 12,
            right: size.width / 12,
            child: Divider(
              color: backColor,
            ),
          ),
        Positioned(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: defaultPadding,
                horizontal: defaultPadding * 2,
              ),
              decoration: BoxDecoration(
                color: backColor,
                borderRadius: BorderRadius.circular(200),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
