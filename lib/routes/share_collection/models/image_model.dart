import 'package:flutter/material.dart';

class ItemModel {
  const ItemModel({required this.index, required this.path});
  final int index;
  final String path;
  @override
  bool operator ==(covariant ItemModel other) =>
      index == other.index && path == other.path;
  @override
  String toString() {
    return '$index: $path';
  }
}

class ImageModel extends ChangeNotifier {
  final List<ItemModel> _imagePaths = [];

  List<ItemModel> get imagePaths => _imagePaths;

  int get length => _imagePaths.length;

  void add(ItemModel path) {
    _imagePaths.add(path);
    notifyListeners();
  }

  void remove(ItemModel path) {
    for (int i = 0; i < _imagePaths.length; i++) {
      if (_imagePaths[i] == path) {
        _imagePaths.removeAt(i);
      }
    }
    notifyListeners();
  }

  void clear() {
    _imagePaths.clear();
    notifyListeners();
  }
}
