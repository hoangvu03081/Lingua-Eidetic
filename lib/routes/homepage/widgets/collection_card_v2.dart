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
    required this.setParentState,
  }) : super(key: key);

  final String title;
  final int avail;
  final int total;
  final VoidCallback remove;
  final VoidCallback setParentState;

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      margin: const EdgeInsets.only(bottom: defaultPadding * 2),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          Navigator.of(context).pushNamed(RouteGenerator.COLLECTION_PAGE,
              arguments: {
                'id': (widget.key as ValueKey).value,
                'title': widget.title
              }).then((value) {
            widget.setParentState();
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
                  dx -= size.width / 25;
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
        child: Stack(
          children: [
            Container(
              transform: Matrix4.translationValues(dx, 0, 0),
              padding: const EdgeInsets.all(defaultPadding * 2),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    offset: const Offset(0, 4),
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
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  Row(
                    children: [
                      // text badge
                      TextBadge(text: '${widget.avail} available'),
                      const SizedBox(width: defaultPadding),
                      TextBadge(
                        text: '${widget.total} total',
                        textColor: Theme.of(context).accentColor,
                        backColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // percent balloon
            Positioned(
              right: defaultPadding * 4 - dx,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: const Color(0xFFFFFFFF),
                    border: Border.all(
                      color: const Color(0xFF638FFF),
                      width: 1,
                    ),
                  ),
                  width: 30,
                  height: 30,
                  child: Center(
                    child: Text(
                      '${getPercentage(widget.avail, widget.total)}%',
                      // '${}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        color: Color(0xFF333D61),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // divider
            Positioned(
              top: 8,
              right: 16 - dx,
              bottom: 8,
              child: SizedBox(
                width: 1.5,
                child: Container(
                  color: const Color(0xFF253F81),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 20 - dx,
              bottom: 8,
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
      ),
    );
  }

  int getPercentage(int avail, int total) {
    if (widget.total != 0) {
      return ((widget.avail / widget.total) * 100).toInt();
    }
    return 0;
  }
}
