import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lingua_eidetic/model/Auth.dart';
import 'package:lingua_eidetic/routes/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    EasyLocalization(
        supportedLocales: [
          Locale('en'),
          Locale('vi'),
        ],
        path: 'assets/translations',
        saveLocale: false,
        useOnlyLangCode: true,
        fallbackLocale: Locale('en'),
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

    return Provider<Auth>(
      create: (_) => Auth(),
      child: MaterialApp(
        title: 'Lingua Eidetic',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        onGenerateRoute: routeGenerator.generateRoute,
        initialRoute: RouteGenerator.HOME_PAGE,
      ),
    );
  }
}
