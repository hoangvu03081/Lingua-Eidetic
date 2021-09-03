import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class DetectObject{

  late File _image;
  late List _recognitions;
  late double _imageWidth, _imageHeight;

  DetectObject(){
    _loadModel();
  }

  _loadModel() async{
    await Tflite.loadModel(
      model: "assets/model_ai/ssd_mobilenet.tflite",
      labels: "assets/model_ai/labels.txt",
    );
  }

  detectObject(File image) async{

    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path,       // required
        model: "SSDMobileNet",
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.4,       // defaults to 0.1
        numResultsPerClass: 10,// defaults to 5
        asynch: true          // defaults to true
    );
    _recognitions = recognitions!;
  }

  List getListRecognition(){
    return _recognitions;
  }

  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    if (_imageWidth == null || _imageHeight == null) return [];

    double factorX = screen.width;
    double factorY = _imageHeight / _imageHeight * screen.width;

    Color blue = Colors.blue;

    return _recognitions.map((re) {
      return Container(
        child: Positioned(
            left: re["rect"]["x"] * factorX,
            top: re["rect"]["y"] * factorY,
            width: re["rect"]["w"] * factorX,
            height: re["rect"]["h"] * factorY,
            child: ((re["confidenceInClass"] > 0.50))? Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: blue,
                    width: 3,
                  )
              ),
              child: Text(
                "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
                style: TextStyle(
                  background: Paint()..color = blue,
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ) : Container()
        ),
      );
    }).toList();
  }
}