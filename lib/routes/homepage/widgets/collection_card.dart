import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';

class CollectionCard extends StatefulWidget {
  CollectionCard({
    Key? key,
    required this.childHeight,
    required this.childWidth,
    required this.defaultTextStyle,
    required this.iconData,
    required this.title,
    required this.left,
    required this.done,
    required this.readOnly,
    this.doneEditing,
  }) : super(key: key);

  ValueChanged? doneEditing;
  final bool readOnly;
  final double childHeight;
  final double childWidth;
  final TextStyle defaultTextStyle;
  final IconData iconData;
  final String title;
  final int left;
  final int done;

  @override
  _CollectionCardState createState() => _CollectionCardState();
}

class _CollectionCardState extends State<CollectionCard> {
  var _focusNode = FocusNode();
  var _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.title;
    if (!widget.readOnly) _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.childHeight,
      width: widget.childWidth,
      decoration: BoxDecoration(
        color: Color(0xFFFAEFEE),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              widget.iconData,
              color: Color(0xFFF0898A),
              size: 34,
            ),
            SizedBox(height: defaultPadding * 4),
            Expanded(
              child: TextField(
                onEditingComplete: () {
                  if (widget.doneEditing != null)
                    widget.doneEditing!(_controller.text);
                },
                controller: _controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.zero),
                readOnly: widget.readOnly,
                focusNode: _focusNode,
                style: widget.defaultTextStyle.copyWith(fontSize: 22),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(1),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFFFAE5E7)),
                    ),
                    child: Text(
                      '${widget.left} left',
                      style: TextStyle(
                        color: Color(0xFFF0898A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0.1),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFFFFFFFF)),
                    ),
                    child: Text(
                      '${widget.done} done',
                      style: TextStyle(color: Color(0xFFD3A2A2)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
