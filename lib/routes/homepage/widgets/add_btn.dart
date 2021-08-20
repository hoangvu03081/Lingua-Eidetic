import 'package:flutter/material.dart';

class AddBtn extends StatelessWidget {
  const AddBtn({Key? key, required this.onTap}) : super(key: key);
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.white, blurRadius: 16, spreadRadius: -12)
            ],
            borderRadius: BorderRadius.circular(16),
            color: Color(0xFF242343),
          ),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}
