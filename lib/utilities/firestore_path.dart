import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Provide frequently used path for Cloud Firestore.
abstract class CloudPath {
  ///'user/$[userId]/collection'
  static String collection(String userId) => 'user/$userId/collection';

  ///'user/$[userId]/collection/$[collectionId]'
  static String card(String userId, String collectionId) =>
      'user/$userId/collection/$collectionId/card';
}

abstract class AppConstant {
  static late final String path;
  static Future<void> init() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    path = appDocDir.path;
  }
}
