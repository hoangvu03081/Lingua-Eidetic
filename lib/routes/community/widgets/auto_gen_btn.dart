import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingua_eidetic/constants.dart';

class AutoGenBtn extends StatelessWidget {
  const AutoGenBtn({
    Key? key,
    required this.onPressed,
  }) : super(key: key);
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IntrinsicWidth(
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(const Color(0xFF587CFE)),
          ),
          child: Row(
            children: [
              SvgPicture.asset('assets/images/wand.svg'),
              const SizedBox(width: defaultPadding),
              const Text(
                'Auto generate caption',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
