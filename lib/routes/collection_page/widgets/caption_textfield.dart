import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';

class CaptionTextField extends StatefulWidget {
  const CaptionTextField({Key? key}) : super(key: key);

  @override
  _CaptionTextFieldState createState() => _CaptionTextFieldState();
}

class _CaptionTextFieldState extends State<CaptionTextField> {
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
      child: const CustomTextField(),
    );
  }
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({Key? key}) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final List<String> _items = ['first'];
  final _controller = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
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
              backgroundColor: Colors.white30,
              labelPadding: const EdgeInsets.only(left: 4, right: 2),
              deleteIconColor: const Color(0xFF172853),
              pressElevation: 0,
              // labelStyle: TextStyle(),
              onPressed: () {},
              onDeleted: () {},
            ),
          ),
        ),
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
    );
  }
}
