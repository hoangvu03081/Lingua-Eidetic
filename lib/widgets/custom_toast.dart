import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(FToast fToast, Widget child, int seconds,
    {double? right, double? bottom, double? left, double? top}) {
  fToast.showToast(
    child: child,
    positionedToastBuilder: (context, child) {
      return Positioned(
          child: child, right: right, bottom: bottom, left: left, top: top);
    },
    toastDuration: Duration(seconds: seconds),
  );
}

class ErrorToast extends StatelessWidget {
  const ErrorToast({
    Key? key,
    required this.errorText,
  }) : super(key: key);
  final String errorText;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.85,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
        boxShadow: const [
          BoxShadow(blurRadius: 6, color: Colors.white),
          BoxShadow(blurRadius: 4, color: Colors.black38),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.close,
            color: Colors.white,
            size: size.height * 0.1,
          ),
          const SizedBox(
            width: 12.0,
          ),
          SizedBox(
            width: size.width * 0.85 - size.height * 0.1 - 60,
            child: Text(
              errorText.toUpperCase().replaceAll(
                  RegExp(
                    r'[^\s\w]',
                  ),
                  ' '),
              style: TextStyle(
                color: Colors.white,
                fontSize: size.height * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
