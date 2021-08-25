import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lingua_eidetic/services/auth_service.dart';

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
  const radius = 50;
  final maxScale = (size.height * 2) / (radius * 2);
  final OverlayState? overlayState = Overlay.of(context);
  final OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
            top: size.height * 0.6,
            left: size.width / 2 - radius,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInCubic,
              tween: Tween<double>(begin: 0, end: maxScale),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: AnimatedOpacity(
                    opacity: 1 - value / maxScale,
                    duration: const Duration(milliseconds: 2000),
                    curve: const DelayedEaseCurve(1500 ~/ 2000),
                    child: child,
                  ),
                );
              },
              child: Container(
                width: radius * 2,
                height: radius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green[600],
                  gradient: const LinearGradient(
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

  final userStreamListener = Auth().authStateChanges().take(2).listen((event) {
    if (event != null) overlayEntry.remove();
  });
  await Future.delayed(const Duration(seconds: 20));
  userStreamListener.cancel();
  overlayEntry.remove();
  throw FirebaseAuthException(code: 'sign-in-takes-to-long');
}
