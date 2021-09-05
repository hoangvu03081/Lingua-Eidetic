import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/models/memory_card.dart';

class CaptionTextField extends StatefulWidget {
  const CaptionTextField({
    Key? key,
    required this.card,
    this.canDelete = true,
    this.canAdding = true,
  }) : super(key: key);
  final MemoryCard card;
  final bool canDelete;
  final bool canAdding;

  @override
  _CaptionTextFieldState createState() => _CaptionTextFieldState();
}

class _CaptionTextFieldState extends State<CaptionTextField> {
  final List<String> _items = [];
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _items.addAll(widget.card.caption);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0x735696FF),
            Color(0x73CF9FFF),
          ],
        ),
      ),
      child: Wrap(
        spacing: defaultPadding,
        children: [
          ..._items.map<Widget>(
            (item) => SizedBox(
              height: 45,
              child: InputChip(
                label: Text(
                  item,
                  style: const TextStyle(
                    color: Color(0xFF465FB8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                visualDensity: VisualDensity.compact,
                backgroundColor: Colors.white30,
                labelPadding:
                    EdgeInsets.only(left: 4, right: widget.canDelete ? 2 : 4),
                deleteIconColor: widget.canDelete
                    ? const Color(0xFF172853)
                    : Colors.transparent,
                pressElevation: 0,
                onPressed: () {},
                onDeleted: widget.canDelete
                    ? () {
                        setState(() {
                          _items.remove(item);
                        });
                      }
                    : null,
              ),
            ),
          ),
          if (widget.canAdding)
            Transform.translate(
              offset: const Offset(0, -2),
              child: SizedBox(
                height: 40,
                child: IntrinsicWidth(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '+ Caption',
                      border: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.zero,
                    ),
                    onEditingComplete: () {},
                    onSubmitted: (String value) {
                      setState(() {
                        _items.add(value);
                      });
                      _controller.clear();
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
