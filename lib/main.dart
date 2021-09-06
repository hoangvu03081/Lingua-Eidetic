import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lingua_eidetic/routes/routes.dart';
import 'package:lingua_eidetic/utilities/app_startup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStartup.init();
  runApp(
    EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('vi'),
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
      initialRoute: RouteGenerator.LANDING_PAGE,
      theme: ThemeData(
        accentColor: const Color(0xFF172853),
        scaffoldBackgroundColor: const Color(0xFFEDF2F5),
      ),
    );
  }
}
