import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingua_eidetic/constants.dart';

class CollectionCard extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final int num;

  const CollectionCard({
    Key? key,
    required this.width,
    required this.height,
    required this.title,
    required this.num,
  }) : super(key: key);

  @override
  _CollectionCardState createState() => _CollectionCardState();
}

class _CollectionCardState extends State<CollectionCard> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                blurRadius: 4, offset: Offset(0, 4), color: Color(0x51000000))
          ],
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              primaryColor,
              secondaryColor,
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? Colors.yellow : Colors.transparent,
            width: 4,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.title,
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: defaultPadding * 1.2,
              right: defaultPadding * 1.2,
              child: Text(
                widget.num.toString(),
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
