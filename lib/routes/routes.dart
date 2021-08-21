import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lingua_eidetic/repositories/card_repository.dart';
import 'package:lingua_eidetic/repositories/collection_repository.dart';
import 'package:lingua_eidetic/routes/reviewpage/review_page.dart';
import 'package:lingua_eidetic/routes/reviewpage/wrong_review_page.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lingua_eidetic/routes/authentication/authentication_page.dart';
import 'package:lingua_eidetic/routes/homepage/homepage.dart';
import 'package:lingua_eidetic/routes/landing_page.dart';
import 'package:lingua_eidetic/routes/test_page.dart';
import 'package:lingua_eidetic/services/collection_service.dart';
import 'package:lingua_eidetic/services/review_service.dart';
import 'package:lingua_eidetic/widgets/dragging_sample.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  static const String LANDING_PAGE = "/";
  static const String SIGN_IN_PAGE = "/sign-in";
  static const String REGISTER_PAGE = "/register";
  static const String HOME_PAGE = "/home";
  static const String REVIEW_PAGE = "/review";
  static const String TEST = "/test";
  static const String WRONG_REVIEW_PAGE = "/wrong";

  final Auth auth = Auth();
  final CollectionRepository collectionRepository = CollectionRepository();
  final CardRepository cardRepository = CardRepository();
  final CollectionService collectionService = CollectionService();
  final ReviewService reviewService = ReviewService();

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
                  return LandingPage();
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
        return MaterialPageRoute(builder: (context) => AuthenticationPage());
      case HOME_PAGE:
        return MaterialPageRoute(
          builder: (context) => Provider<Auth>.value(
            value: auth,
            builder: (_, __) => HomePage(),
          ),
        );
      case REVIEW_PAGE:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<ReviewService>(
              create: (_) => ReviewService(), builder: (_, __) => ReviewPage()),
        );
      //TODO: change settings.arguments
      case WRONG_REVIEW_PAGE:
        return MaterialPageRoute(
            builder: (context) => WrongReviewPage(
                wrong: settings.arguments as Map<String, dynamic>));
      case TEST:
        return MaterialPageRoute(builder: (context) => TestPage());
      default:
        throw PlatformException(code: '404', message: 'Route not found');
    }
  }
}
