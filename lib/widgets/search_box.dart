import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key, required this.filterFunc}) : super(key: key);
  final ValueChanged<String> filterFunc;

  @override
  Widget build(BuildContext context) {
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
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(100),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: defaultPadding * 3,
          vertical: defaultPadding * 2,
        ),
        hintText: 'Search',
        hintStyle: TextStyle(color: Colors.black54),
      ),
    );
  }
}
