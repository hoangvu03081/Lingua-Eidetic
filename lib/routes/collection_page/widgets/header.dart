import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lingua_eidetic/routes/routes.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.height,
    required this.title,
    required this.onPrevClicked,
  }) : super(key: key);
  final double height;
  final String title;
  final VoidCallback onPrevClicked;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onPrevClicked,
            child: Icon(
              Icons.keyboard_arrow_left,
              color: Color(0xFF172853),
              size: 70,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF172853),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(RouteGenerator.REVIEW_PAGE);
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Color(0xFF172853),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_right_alt_rounded,
                color: Colors.white,
                size: 35,
              ),
            ),
          )
        ],
      ),
      height: height,
    );
  }
}
