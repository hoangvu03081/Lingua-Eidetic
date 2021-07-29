import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lingua_eidetic/routes/authentication/authentication_page.dart';
import 'package:lingua_eidetic/routes/home_page.dart';
import 'package:lingua_eidetic/routes/landing_page.dart';
import 'package:lingua_eidetic/routes/test_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  static const String LANDING_PAGE = "/";
  static const String SIGN_IN_PAGE = "/sign-in";
  static const String REGISTER_PAGE = "/register";
  static const String HOME_PAGE = "/home";
  static const String TEST = "/test";

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LANDING_PAGE:
        return MaterialPageRoute(builder: (context) {
          final auth = Provider.of<Auth>(context);
          return StreamBuilder(
            stream: auth.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final user = snapshot.data;
                if (user == null) {
                  /// landing page has login and register button
                  return LandingPage();
                }

                /// return homepage
                return Scaffold();
              }
              return CircularProgressIndicator();
            },
          );
        });
      case SIGN_IN_PAGE:
        return PageTransition(
          child: AuthenticationPage(),
          type: PageTransitionType.leftToRight,
          duration: Duration(seconds: 1),
        );
      case HOME_PAGE:
        return MaterialPageRoute(builder: (context) => HomePage());
      case TEST:
        return MaterialPageRoute(builder: (context) => TestPage());
      default:
        throw PlatformException(code: '404', message: 'Route not found');
    }
  }
}
