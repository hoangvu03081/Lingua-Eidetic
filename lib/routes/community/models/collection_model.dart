import 'package:flutter/material.dart';
import 'package:lingua_eidetic/services/community_service.dart';

class CServiceModel extends ChangeNotifier {
  final CommunityService service;

  CServiceModel({Key? key, required this.service});

  void love() {
    service.love();
    notifyListeners();
  }

  void download() {
    service.downloadCollection();
    notifyListeners();
  }
}
