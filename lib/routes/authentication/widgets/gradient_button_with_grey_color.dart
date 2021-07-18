import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';

class GradientButtonWithGreyBorder extends StatelessWidget {
  final String text;
  final Function()? press;

  const GradientButtonWithGreyBorder({
    Key? key,
    this.press,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: press,
      overlayColor:
      MaterialStateProperty.all(Color(0xFF891212)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          left: defaultPadding * 2,
          right: defaultPadding * 2,
          bottom: defaultPadding * 1.5,
          top: defaultPadding * 1.2,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFFE4E4E4),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: [0, 0.6],
            colors: [
              Color(0xDAFF2358),
              Color(0xDAFF5B27),
            ],
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
