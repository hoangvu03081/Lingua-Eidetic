import 'package:flutter/material.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lottie/lottie.dart';

import 'auth_page.dart';

class StartupAnimation extends StatefulWidget {
  const StartupAnimation({Key? key}) : super(key: key);

  @override
  _StartupAnimationState createState() => _StartupAnimationState();
}

class _StartupAnimationState extends State<StartupAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  double _fadeOpacity = 1;
  double _loginOpacity = 0;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() => _fadeOpacity = 0);
        await Future.delayed(const Duration(milliseconds: 999));
        setState(() {
          _isFinished = true;
          _loginOpacity = 1;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Builder(
            builder: (context) {
              if (!_isFinished) {
                return AnimatedOpacity(
                  opacity: _fadeOpacity,
                  curve: Curves.easeIn,
                  duration: const Duration(seconds: 1),
                  child: LottieBuilder.asset(
                    'assets/startup2.json',
                    frameRate: FrameRate(24),
                    controller: _controller,
                    onLoaded: (composition) {
                      _controller
                        ..duration = composition.duration
                        ..forward();
                    },
                  ),
                );
              }
              return AnimatedOpacity(
                  opacity: _loginOpacity,
                  curve: Curves.easeIn,
                  duration: const Duration(seconds: 1),
                  child: const AuthPage());
            },
          )),
    );
  }
}
