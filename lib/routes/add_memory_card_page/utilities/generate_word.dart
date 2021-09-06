import 'package:lingua_eidetic/routes/add_memory_card_page/utilities/object_detection.dart';
import 'dart:io';

class GenerationCap {
  late DetectObject _object;
  final List<List<String>> _fullCaption = [];

  GenerationCap() {
    _object = DetectObject();
  }

  void makeCaptionfromList(List listImagePath) {
    for (int i = 0; i < listImagePath.length; i++) {
      makeCaptionfromImg(i, listImagePath[i]);
    }
  }

  List<String> getStringCaption(int index) => _fullCaption[index];

  Future makeCaptionfromImg(int index, String imagePath) async {
    await _object.detectObject(File(imagePath));
    while (_fullCaption.length <= index) {
      _fullCaption.add([]);
    }
    for (int i = 0; i < _object.getListRecognition().length; i++) {
      _fullCaption[index].add(_object.getListRecognition()[i]["detectedClass"]);
    }
  }
}
