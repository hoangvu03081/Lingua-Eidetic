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
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12.0),
          Text(
            errorText.toUpperCase().replaceAll(
                RegExp(
                  r'[^\s\w]',
                ),
                ' '),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
