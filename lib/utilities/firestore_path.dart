import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Provide frequently used path for Cloud Firestore.
abstract class CloudPath {
  ///'user/$userId/collection'
  static String collection(String userId) => 'user/$userId/collection';

  ///'user/$userId/collection/$collectionId'
  static String card(String userId, String collectionId) =>
      'user/$userId/collection/$collectionId/card';

  static get sharedCollection => 'shared_collection';

  ///'shared_collection/$collectionId/cards';
  static String sharedCards(String collectionId) =>
      'shared_collection/$collectionId/cards';
}

abstract class AppConstant {
  static late final String path;
  static Future<void> init() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    path = appDocDir.path;
  }

  /// return image using memory card id
  static String getImage(String cardId) => '$path/$cardId.png';
}

/// ReviewStatus is used when user enter incorrect value in ReviewPage,\
/// user is moved to ReviewWrong Page,
/// and user is allowed to choose 1 of the 3 options:
/// 1. **CONTINUE**: this option will lower the card's exp to 0
/// 2. **ADD**: this option adds the wrong inputted word to the card's caption
/// 3. **IGNORE**: this option will do nothing (no lower exp!)
enum ReviewStatus { ADD, CONTINUE, IGNORE }

enum ImageType { FILE, NETWORK, NOT_AVAILABLE }
