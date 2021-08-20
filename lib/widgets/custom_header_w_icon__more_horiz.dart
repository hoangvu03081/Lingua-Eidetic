import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 20,
        ),
        SizedBox(width: defaultPadding),
        Text('Hi, John Leo!'),
        Spacer(),
        Icon(
          Icons.more_horiz_outlined,
        ),
      ],
    );
  }
}
