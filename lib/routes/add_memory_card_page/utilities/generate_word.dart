import 'package:lingua_eidetic/routes/add_memory_card_page/utilities/object_detection.dart';
import 'dart:io';

class GenerationCap{
  late DetectObject _object;
  late List _listCap;
  String _fullCaption = "";

  GenerationCap(){
    _object = DetectObject();
  }

  void makeCaptionfromList(List listImagePath) {
    for(int i = 0; i < listImagePath.length; i++){
      makeCaptionfromImg(listImagePath[i]);
    }
  }

  String getStringCaption() {
    return _fullCaption;
  }

  Future makeCaptionfromImg(String imagePath) async{
    await _object.detectObject(File(imagePath));
    for(int i = 0; i  < _object.getListRecognition().length; i++){
      _fullCaption += _object.getListRecognition()[i]["detectedClass"] + " ";
    }
  }
}