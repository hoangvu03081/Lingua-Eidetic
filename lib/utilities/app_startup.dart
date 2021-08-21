import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lingua_eidetic/services/card_service.dart';
import 'package:lingua_eidetic/services/image_service.dart';
import 'package:lingua_eidetic/utilities/firestore_path.dart';

abstract class AppStartup {
  static Future<void> init() async {
    await EasyLocalization.ensureInitialized();
    await Firebase.initializeApp();
    FirebaseFirestore.instance.settings =
        const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

    await Hive.initFlutter();
    await Hive.openBox<List<String>>('image_queue');

    await AppConstant.init();
    CardService().init();
  }
}
