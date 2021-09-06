import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lingua_eidetic/constants.dart';

void showToast({
  required FToast fToast,
  required Widget child,
  int seconds = 3,
  double? right,
  double? bottom,
  double? left,
  double? top,
}) {
  final duration = Duration(seconds: seconds);
  fToast.showToast(
    child: child,
    positionedToastBuilder: (context, child) {
      return Positioned(
          child: child, right: right, bottom: bottom, left: left, top: top);
    },
    toastDuration: duration,
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
    return Card(
      color: const Color(0xFFEF5350),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: defaultPadding * 2,
          horizontal: defaultPadding,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber,
                size: 40,
                color: Colors.white,
              ),
              const SizedBox(height: defaultPadding * 2),
              Text(
                errorText.toUpperCase().replaceAll(
                    RegExp(
                      r'[^\s\w]',
                    ),
                    ' '),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: defaultPadding / 2 + 24),
            ],
          ),
        ),
      ),
    );
  }
}

class SuccessToast extends StatelessWidget {
  const SuccessToast({
    Key? key,
    required this.successText,
  }) : super(key: key);
  final String successText;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      color: Colors.greenAccent,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: defaultPadding * 2,
          horizontal: defaultPadding,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check,
                size: 40,
                color: Colors.black,
              ),
              const SizedBox(height: defaultPadding * 2),
              Text(
                successText.toUpperCase().replaceAll(
                    RegExp(
                      r'[^\s\w]',
                    ),
                    ' '),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: defaultPadding / 2 + 24),
            ],
          ),
        ),
      ),
    );
  }
}
