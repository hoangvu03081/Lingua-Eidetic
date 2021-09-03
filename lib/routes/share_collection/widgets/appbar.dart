import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';

PreferredSizeWidget getCustomAppBar(BuildContext context, String title,
    {List<Widget>? actions}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: const Icon(
        Icons.chevron_left,
        color: Color(0xFF172853),
        size: 30,
      ),
    ),
    leadingWidth: 30,
    title: Text(
      title,
      style: const TextStyle(
        color: Color(0xFF172853),
      ),
    ),
    centerTitle: true,
    actions: actions,
  );
}
