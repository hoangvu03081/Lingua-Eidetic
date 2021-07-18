import 'package:flutter/material.dart';

class WelcomeText extends StatelessWidget {
  final String title;
  final String subtitle;

  const WelcomeText({
    Key? key, required this.title, required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              fontFamily: 'Yantramanav',
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: subtitle,
            style: TextStyle(
              fontFamily: 'Yantramanav',
              fontWeight: FontWeight.w500,
              fontSize: 28,
              color: Color(0xFFC6C6C6),
            ),
          ),
        ],
      ),
    );
  }
}