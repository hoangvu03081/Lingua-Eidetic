import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key, required this.filterFunc}) : super(key: key);
  final ValueChanged<String> filterFunc;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return TextField(
      onChanged: (value) {
        filterFunc(value);
      },
      decoration: InputDecoration(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(100),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: defaultPadding * 2,
          vertical: defaultPadding * 1.5,
        ),
        hintText: 'Search',
        hintStyle: const TextStyle(
          color: Colors.black54,
          fontSize: 14,
        ),
      ),
    );
  }
}
