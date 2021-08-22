import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/text_badge.dart';
import 'package:lingua_eidetic/routes/routes.dart';

class CollectionCardV2 extends StatefulWidget {
  const CollectionCardV2({
    Key? key,
    required this.title,
    required this.avail,
    required this.total,
    required this.remove,
  }) : super(key: key);

  final String title;
  final int avail;
  final int total;
  final VoidCallback remove;

  @override
  _CollectionCardV2State createState() => _CollectionCardV2State();
}

class _CollectionCardV2State extends State<CollectionCardV2> {
  double dx = 0;
  double startX = 0;
  double endX = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.of(context).pushNamed(RouteGenerator.COLLECTION_PAGE,
                  arguments: {
                    'id': (widget.key as ValueKey).value,
                    'title': widget.title
                  });
            },
            onHorizontalDragStart: (details) {
              startX = details.globalPosition.dx;
            },
            onHorizontalDragUpdate: (details) {
              setState(() {
                dx = details.globalPosition.dx - startX;
              });
            },
            onHorizontalDragEnd: (details) {
              double v = details.velocity.pixelsPerSecond.dx;
              if (dx <= -size.width / 2 || v < -1000) {
                // delete
                const dur = Duration(milliseconds: 40);
                Timer.periodic(dur, (Timer t) {
                  setState(() {
                    if (v < -1000) {
                      dx += v / 25;
                    } else {
                      dx -= size.width / 40;
                    }
                  });
                  if (dx <= -size.width) {
                    widget.remove();
                    t.cancel();
                  }
                });
              } else {
                setState(() {
                  dx = 0;
                });
              }
            },
            child: Container(
              transform: Matrix4.translationValues(dx, 0, 0),
              margin: const EdgeInsets.only(bottom: defaultPadding * 2),
              padding: const EdgeInsets.symmetric(
                vertical: defaultPadding * 2,
                horizontal: defaultPadding * 3,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF172853),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    color: Colors.black.withOpacity(0.25),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width:
                        MediaQuery.of(context).size.width - defaultPadding * 16,
                    child: Text(
                      widget.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: defaultPadding * 4),
                  Row(
                    children: [
                      // text badge
                      TextBadge(text: '${widget.avail} available'),
                      const SizedBox(width: defaultPadding),
                      TextBadge(
                        text: '${widget.total} total',
                        textColor: const Color(0xFF172853),
                        backColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: defaultPadding * 4 - dx,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color(0xFFFFFFFF),
                border: Border.all(
                  color: const Color(0xFF638FFF),
                  width: 1,
                ),
              ),
              width: 50,
              height: 50,
              child: Center(
                child: Text(
                  '${(widget.avail / widget.total * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF333D61),
                  ),
                ),
              ),
            ),
          ),
          // divider
          Positioned(
            top: 0,
            right: 16 - dx,
            child: SizedBox(
              width: 1.5,
              height: 134,
              child: Container(
                color: const Color(0xFF253F81),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 20 - dx,
            child: SizedBox(
              width: 2,
              height: 134,
              child: Container(
                color: const Color(0xFF253F81),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
