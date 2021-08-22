import 'package:flutter/material.dart';

class AddBtn extends StatelessWidget {
  const AddBtn({Key? key, required this.onTap}) : super(key: key);
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size.height * 0.0672,
          height: size.height * 0.0672,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 1,
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: Color(0xFF242343),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}
