import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingua_eidetic/constants.dart';

class SignInTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function()? onEditingComplete;
  final String? errorText;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;

  const SignInTextField({
    Key? key,
    required this.label,
    this.controller,
    this.focusNode,
    this.onEditingComplete,
    this.errorText,
    this.textInputAction,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        errorText: errorText,
        contentPadding: EdgeInsets.symmetric(
            vertical: defaultPadding * 2.5, horizontal: defaultPadding * 3),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFE4E4E4),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFF2358),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFF2358),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFF2358),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        errorMaxLines: 2,
        labelText: label,
        labelStyle: GoogleFonts.openSans(
          textStyle: TextStyle(
            color: Color(0xFFBDBCBC),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
