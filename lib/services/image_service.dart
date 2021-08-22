import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lingua_eidetic/utilities/firestore_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageService {
  final Auth _auth = Auth();
  final ImagePicker _imagePicker = ImagePicker();

  /// image queue, each element in queue is a array of 2 string, first string is collection id of that image
  ///
  /// second string is the image name of which format is [id.png] where id is the card id that contains the image.
  final Box<List<String>> _box = Hive.box('image_queue');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// return an image [File] by capturing photo using camera
  Future<String?> getImageFromCamera() async {
    final imageFile = await _imagePicker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
    if (imageFile == null) return null;
    return imageFile.path;
  }

  /// return a list of image [File] by multiple selection in gallery. Only compatible with Android 4.3 or higher.
  Future<List<String>?> getMutlipleImages() async {
    final imagePaths = await _imagePicker.pickMultiImage();
    if (imagePaths == null || imagePaths.isEmpty) return null;
    return imagePaths.map((e) => e.path).toList();
  }

  void addImageToQueue(String collectionId, String imageName) {
    List<String> image = [imageName, collectionId];
    _box.add(image);
  }

  /// initialize uploading queue, which starts uploading images from image queue every interval of 5 seconds
  Future<void> uploadQueueInit(
      void Function(
              {required String collectionId,
              required String cardId,
              required String imagePath})
          editCard) async {
    while (true) {
      final ConnectivityResult connectivityResult =
          await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.none &&
          _auth.currentUser != null) {
        print('start uploading image...');
        await _uploadImage(editCard);
      }

      await Future.delayed(const Duration(seconds: 5));
    }
  }

  /// upload image from queue
  Future<bool> _uploadImage(
      void Function(
              {required String collectionId,
              required String cardId,
              required String imagePath})
          editCard) async {
    while (_box.isNotEmpty) {
      String filePath = AppConstant.path;
      String cloudImagePath =
          await _uploadFile(filePath, _box.values.first.elementAt(0));
      editCard(
          collectionId: _box.values.first.elementAt(1),
          cardId: _box.values.first.elementAt(0),
          imagePath: cloudImagePath);
      _box.deleteAt(0);
    }
    return true;
  }

  /// upload general file to cloud storage
  Future<String> _uploadFile(String filePath, String fileName) async {
    File file = File(filePath + '/' + fileName);
    try {
      final cloudImage = await _storage.ref(fileName).putFile(file);
      return cloudImage.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      log('fail to upload to cloud storage: ${e.code}/${e.message}');
    }
    return '';
  }

  void removeImage(String cardId) async {
    try {
      String fileName = cardId + '.png';
      final cloudImage = _storage.ref(fileName);
      await cloudImage.delete();
      await File(AppConstant.path + '/' + fileName).delete();
    } catch (e) {
      print(e);
    }
  }

  void printHive() {
    for (dynamic i in _box.keys) {
      print('$i : ${_box.get(i)}');
    }
  }

  ///return a singleton instance of [ImageService]
  ImageService._();
  static final ImageService _imageService = ImageService._();
  factory ImageService() {
    return _imageService;
  }
}
