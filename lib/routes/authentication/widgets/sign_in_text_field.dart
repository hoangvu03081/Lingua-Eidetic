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
  final bool obscureText;

  const SignInTextField({
    Key? key,
    required this.label,
    this.controller,
    this.focusNode,
    this.onEditingComplete,
    this.errorText,
    this.textInputAction,
    this.onChanged,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      textInputAction: textInputAction,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        errorText: errorText,
        contentPadding: const EdgeInsets.symmetric(
            vertical: defaultPadding, horizontal: defaultPadding * 2),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFE4E4E4),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFFF2358),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFFF2358),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFFF2358),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        errorMaxLines: 2,
        labelText: label,
        labelStyle: GoogleFonts.openSans(
          textStyle: const TextStyle(
            color: Color(0xFFBDBCBC),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
