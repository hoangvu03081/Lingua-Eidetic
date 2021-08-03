import 'package:flutter/material.dart';

class OpacityAnimation extends StatefulWidget {
  final bool trigger;
  final VoidCallback changeText;
  final Widget child;
  final int duration;

  const OpacityAnimation(
      {Key? key,
      required this.changeText,
      required this.trigger,
      required this.child,
      required this.duration})
      : super(key: key);

  @override
  _OpacityAnimationState createState() => _OpacityAnimationState();
}

class _OpacityAnimationState extends State<OpacityAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  int count = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration ~/ 2),
      lowerBound: 0,
      upperBound: 1,
    );

    controller.addListener(() {
      setState(() {});
    });
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        /// forward -> complete
        --count;
        if (count != 0) controller.reverse(from: 1);
      } else if (status == AnimationStatus.dismissed) {
        /// reverse -> dismissed
        --count;
        widget.changeText();
        if (count != 0) controller.forward(from: 0);
      }
    });
    opacityAnimation = CurvedAnimation(
        parent: controller, curve: Curves.easeIn, reverseCurve: Curves.easeIn);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool toggle = true;
  bool first = true;

  void animate() {
    setState(() {
      toggle = !toggle;
      count = first ? 3 : 2;
      first = false;
    });
    controller.reverse(from: 1);
  }
  @override
  Widget build(BuildContext context) {
    if (widget.trigger != toggle) animate();
    return Opacity(
      opacity: first ? 1 : opacityAnimation.value,
      child: widget.child,
    );
  }
}
