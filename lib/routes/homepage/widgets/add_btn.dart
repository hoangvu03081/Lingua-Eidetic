import 'package:flutter/material.dart';
import 'package:lingua_eidetic/widgets/collection_navbar.dart';
import 'package:rive/rive.dart';

class AddBtn extends StatefulWidget {
  const AddBtn({Key? key, required this.openAddForm}) : super(key: key);

  final VoidCallback openAddForm;

  @override
  _AddBtnState createState() => _AddBtnState();
}

class _AddBtnState extends State<AddBtn> {
  void _onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    artboard.addController(controller!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onTapUp: onTapListener,
        child: SizedBox(
          height: 50,
          child: RiveAnimation.asset(
            'assets/lingua_eidetic.riv',
            fit: BoxFit.contain,
            onInit: _onRiveInit,
            artboard: 'navbar',
            antialiasing: true,
          ),
        ));
  }

  void onTapListener(TapUpDetails details) {
    Size size = MediaQuery.of(context).size;
    final double x = details.localPosition.dx;
    final double y = details.localPosition.dy;
    if (size.width * 0.45 <= x && x <= size.width * 0.55 && y >= 5 && y <= 40) {
      widget.openAddForm();
    }
  }
}
