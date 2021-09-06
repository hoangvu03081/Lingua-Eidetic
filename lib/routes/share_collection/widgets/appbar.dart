import 'package:flutter/material.dart';

PreferredSizeWidget getCustomAppBar(BuildContext context, String title,
    {List<Widget>? actions}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    titleSpacing: 0,
    leading: GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Icon(
        Icons.chevron_left,
        color: Theme.of(context).accentColor,
        size: 30,
      ),
    ),
    leadingWidth: 30,
    title: Text(
      title,
      style: Theme.of(context).textTheme.headline5!.copyWith(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
    ),
    centerTitle: true,
    actions: actions,
  );
}
