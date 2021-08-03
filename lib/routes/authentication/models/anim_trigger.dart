import 'package:flutter/material.dart';

class AnimTriggerModel extends ChangeNotifier {
  bool _trigger = false;
  final int _duration;

  AnimTriggerModel({trigger, duration})
      : _trigger = trigger,
        _duration = duration;

  bool get trigger => _trigger;

  int get duration => _duration;

  void setTrigger(trigger) {
    _trigger = trigger;
    notifyListeners();
  }
}
