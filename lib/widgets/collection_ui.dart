import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/widgets/collection_card.dart';

class CollectionUI extends StatefulWidget {
  final double gapX = 40;
  final double horizontalMargin = 30;
  final double gapY = 20;
  final int rowItemCount = 2;
  final double childHeight = 172;
  final data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14];

  CollectionUI({Key? key}) : super(key: key);

  @override
  _CollectionUIState createState() => _CollectionUIState();
}

class _CollectionUIState extends State<CollectionUI> {
  @override
  void initState() {
    super.initState();
    setState(() {
      data = widget.data;
    });
  }

  List<int> data = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            /// source sans pro
            width: double.infinity,
            margin: EdgeInsets.only(bottom: defaultPadding * 2),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  data.removeAt(0);
                });
              },
              child: Text(
                'Collections',
                textAlign: TextAlign.center,
                style: GoogleFonts.sourceSansPro(
                  textStyle: TextStyle(
                    fontSize: 32,
                    color: primaryColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: primaryColor, width: 1))),
          ),
          Container(
            margin: EdgeInsets.only(top: defaultPadding),
            height:
                (data.length / 2).ceil() * (widget.childHeight + widget.gapY),
            width: size.width,
            child: Stack(
              children: _buildChildren(),
            ),
          ),
        ],
      ),
    );
  }

  double? childWidth;

  _buildChildren() {
    List<Widget> children = [];
    final width = MediaQuery.of(context).size.width;
    final gapX = widget.gapX;
    final gapY = widget.gapY;
    final rowItemCount = widget.rowItemCount;
    final horizontalMargin = widget.horizontalMargin;
    final childHeight = widget.childHeight;
    childWidth = (width - gapX * (rowItemCount - 1)) / rowItemCount -
        horizontalMargin * 2 / rowItemCount;

    for (int i = data.length - 1; i >= 0; i--) {
      var leftOffset = i % rowItemCount == 0
          ? horizontalMargin
          : (childWidth! + gapX) * (i % rowItemCount) + horizontalMargin;
      final yOffset = (childHeight + gapY) * (i ~/ rowItemCount);
      children.add(AnimatedPositioned(
        duration: Duration(milliseconds: 800),
        left: i % rowItemCount == 0 ? leftOffset : leftOffset,
        top: yOffset,
        child: CollectionCard(
          width: childWidth!,
          height: childHeight,
          title: data[i].toString(),
          num: i,
        ),
      ));
    }
    return children;
  }
}
