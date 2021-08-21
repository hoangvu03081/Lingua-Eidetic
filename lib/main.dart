import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lingua_eidetic/routes/routes.dart';
import 'package:lingua_eidetic/utilities/app_startup.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStartup.init();
  runApp(
    EasyLocalization(
        supportedLocales: [
          const Locale('en'),
          const Locale('vi'),
        ],
        path: 'assets/translations',
        saveLocale: false,
        useOnlyLangCode: true,
        fallbackLocale: const Locale('en'),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  final routeGenerator = RouteGenerator();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Lingua Eidetic',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      onGenerateRoute: routeGenerator.generateRoute,
      initialRoute: RouteGenerator.REVIEW_PAGE,
    );
  }
}
