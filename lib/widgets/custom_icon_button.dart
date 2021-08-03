import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget icon;
  const CustomIconButton({Key? key, required this.onTap, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              spreadRadius: -2,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: icon,
      ),
    );
  }
}
