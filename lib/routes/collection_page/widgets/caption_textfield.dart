import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';

class CaptionTextField extends StatefulWidget {
  const CaptionTextField({
    Key? key,
    required this.items,
    this.canDelete = true,
    this.canAdding = true,
    this.onChange,
  }) : super(key: key);
  final bool canDelete;
  final bool canAdding;
  final List<String> items;
  final ValueChanged<List<String>>? onChange;

  @override
  _CaptionTextFieldState createState() => _CaptionTextFieldState();
}

class _CaptionTextFieldState extends State<CaptionTextField> {
  final List<String> _items = [];
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (String value in widget.items) {
      if (!(_items.contains(value) || value.trim() == '')) {
        _items.add(value);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: size.height * 0.2),
      child: Container(
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
                      ? Theme.of(context).accentColor
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
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: defaultPadding),
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
                        if (value.trim() != '' && !_items.contains(value)) {
                          setState(() {
                            _items.add(value);
                          });
                        }
                        _controller.clear();
                        if (widget.onChange != null) {
                          widget.onChange!(_items);
                        }
                      },
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
