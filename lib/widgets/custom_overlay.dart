import 'dart:math';
import 'package:flutter/material.dart';

class DelayedEaseCurve extends Curve {
  final int delay;

  const DelayedEaseCurve(this.delay);

  @override
  double transformInternal(double t) {
    return t < delay ? 0 : pow(t - delay, 2).toDouble();
  }
}

Future<void> showOverlay(BuildContext context) async {
  final size = MediaQuery.of(context).size;
  final radius = 50;
  final maxScale = (size.height * 1.4) / (radius * 2);
  OverlayState? overlayState = Overlay.of(context);
  OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: size.height * 0.6,
        left: size.width / 2 - radius,
        child: TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInCubic,
          tween: Tween<double>(begin: 0, end: maxScale),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: AnimatedOpacity(
                  opacity: 1 - value / maxScale,
                  duration: Duration(milliseconds: 2000),
                  curve: DelayedEaseCurve(1500 ~/ 2000),
                  child: child),
            );
          },
          child: Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green[600],
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: [0, 0.6],
                colors: [
                  Color(0xFFFF2358),
                  Color(0xFFFF5B27),
                ],
              ),
            ),
          ),
        ),
      ));
  overlayState?.insert(overlayEntry);
  await Future.delayed(Duration(milliseconds: 1000));
  await Future.delayed(Duration(milliseconds: 5000));
  overlayEntry.remove();
}