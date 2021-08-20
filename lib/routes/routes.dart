import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lingua_eidetic/repositories/card_repository.dart';
import 'package:lingua_eidetic/repositories/collection_repository.dart';
import 'package:lingua_eidetic/routes/homepage/homepage_v2.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lingua_eidetic/routes/authentication/authentication_page.dart';
import 'package:lingua_eidetic/routes/homepage/homepage.dart';
import 'package:lingua_eidetic/routes/landing_page.dart';
import 'package:lingua_eidetic/routes/test_page.dart';
import 'package:lingua_eidetic/services/collection_service.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  static const String LANDING_PAGE = "/";
  static const String SIGN_IN_PAGE = "/sign-in";
  static const String HOME_PAGE = "/home";
  static const String TEST = "/test";

  final Auth auth = Auth();
  final CollectionRepository collectionRepository = CollectionRepository();
  final CardRepository cardRepository = CardRepository();
  final CollectionService collectionService = CollectionService();

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LANDING_PAGE:
        return MaterialPageRoute(builder: (context) {
          return StreamBuilder(
            stream: auth.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final user = snapshot.data;
                if (user == null) {
                  /// landing page has login and register button
                  return ChangeNotifierProvider<CollectionService>.value(
                      value: collectionService,
                      builder: (_, __) => LandingPage());
                }

                /// return homepage
                return ChangeNotifierProvider<CollectionService>.value(
                    value: collectionService,
                    builder: (_, __) => LandingPage());
              }
              return CircularProgressIndicator();
            },
          );
        });
      case SIGN_IN_PAGE:
        return MaterialPageRoute(
          builder: (context) => Provider<Auth>.value(
            value: auth,
            builder: (context, child) => AuthenticationPage(),
          ),
        );
      case HOME_PAGE:
        return MaterialPageRoute(
          builder: (context) => Provider<Auth>.value(
            value: auth,
            builder: (_, __) => HomePageV2(),
          ),
        );
      case TEST:
        return MaterialPageRoute(builder: (context) => TestPage());
      default:
        throw PlatformException(code: '404', message: 'Route not found');
    }
  }
}
