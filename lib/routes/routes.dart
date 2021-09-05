import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lingua_eidetic/models/memory_card.dart';
import 'package:lingua_eidetic/repositories/card_repository.dart';
import 'package:lingua_eidetic/repositories/collection_repository.dart';
import 'package:lingua_eidetic/routes/collection_page/editing_collection_page.dart';
import 'package:lingua_eidetic/routes/community/community_page.dart';
import 'package:lingua_eidetic/routes/reviewpage/review_page.dart';
import 'package:lingua_eidetic/routes/reviewpage/wrong_review_page.dart';
import 'package:lingua_eidetic/routes/add_memory_card_page/add_memory_card_page.dart';
import 'package:lingua_eidetic/routes/collection_page/collection_page.dart';
import 'package:lingua_eidetic/routes/homepage/homepage_v2.dart';
import 'package:lingua_eidetic/routes/share_collection/description_images_page.dart';
import 'package:lingua_eidetic/routes/share_collection/preview_share_page.dart';
import 'package:lingua_eidetic/routes/share_collection/share_collection_page.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lingua_eidetic/routes/authentication/authentication_page.dart';
// import 'package:lingua_eidetic/routes/homepage/homepage.dart';
import 'package:lingua_eidetic/routes/landing_page.dart';
import 'package:lingua_eidetic/routes/test_page.dart';
import 'package:lingua_eidetic/services/collection_service.dart';
import 'package:lingua_eidetic/services/review_service.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'auth/auth_page.dart';

class RouteGenerator {
  static const String LANDING_PAGE = "/";
  static const String SIGN_IN_PAGE = "/sign-in";
  static const String HOME_PAGE = "/home";
  static const String REVIEW_PAGE = "/review";
  static const String TEST = "/test";
  static const String WRONG_REVIEW_PAGE = "/wrong";
  static const String COLLECTION_PAGE = "/collection";
  static const String ADD_COLLECTION_PAGE = "/add-collection";
  static const String COMMUNITY_PAGE = "/community";
  static const String SHARE_COLLECTION_PAGE = "/share-collection";
  static const String DESCRIPTION_IMAGES_PAGE = "/description-images";
  static const String PREVIEW_SHARE_PAGE = "/preview-share";
  static const String EDITING_COLLECTION_PAGE = "/edit-collection";

  final Auth auth = Auth();
  final CollectionRepository collectionRepository = CollectionRepository();
  final CardRepository cardRepository = CardRepository();
  final CollectionService collectionService = CollectionService();
  final ReviewService reviewService = ReviewService();

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LANDING_PAGE:
        return MaterialPageRoute(builder: (context) {
          return LandingPage();
          return StreamBuilder(
            stream: auth.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final user = snapshot.data;
                if (user == null) {
                  /// landing page has login and register button
                  return Provider<Auth>.value(
                    value: auth,
                    builder: (context, child) => const AuthPage(),
                  );
                }

                /// return homepage
                return Provider<Auth>.value(
                  value: auth,
                  builder: (_, __) => const HomePageV2(),
                );
              }
              return const SizedBox();
            },
          );
        });
      case SIGN_IN_PAGE:
        return MaterialPageRoute(
          builder: (context) => Provider<Auth>.value(
            value: auth,
            builder: (context, child) => const AuthenticationPage(),
          ),
        );
      case HOME_PAGE:
        return MaterialPageRoute(
          builder: (context) => Provider<Auth>.value(
            value: auth,
            builder: (_, __) => const HomePageV2(),
          ),
        );
      case COLLECTION_PAGE:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => Provider<Auth>.value(
            value: auth,
            builder: (_, __) => CollectionPage(
                id: arguments['id']!, title: arguments['title']!),
          ),
        );
      case ADD_COLLECTION_PAGE:
        final arguments = settings.arguments as List<String>?;
        return MaterialPageRoute(
          builder: (context) => Provider<Auth>.value(
            value: auth,
            builder: (_, __) => AddMemoryCardPage(images: arguments),
          ),
        );
      case REVIEW_PAGE:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<ReviewService>(
              create: (_) => ReviewService(),
              builder: (_, __) => const ReviewPage()),
        );
      case WRONG_REVIEW_PAGE:
        return MaterialPageRoute(
            builder: (context) => WrongReviewPage(
                wrong: settings.arguments as Map<String, dynamic>));
      case COMMUNITY_PAGE:
        return MaterialPageRoute(
          builder: (context) => Provider<Auth>.value(
            value: auth,
            builder: (_, __) => const CommunityPage(),
          ),
        );
      case SHARE_COLLECTION_PAGE:
        return MaterialPageRoute(
          builder: (context) => Provider<Auth>.value(
            value: auth,
            builder: (_, __) => const ShareCollectionPage(),
          ),
        );
      case DESCRIPTION_IMAGES_PAGE:
        return MaterialPageRoute(
          builder: (context) => Provider<Auth>.value(
            value: auth,
            builder: (_, __) => const DescriptionImagesPage(),
          ),
        );
      case PREVIEW_SHARE_PAGE:
        return MaterialPageRoute(
          builder: (context) => Provider<Auth>.value(
            value: auth,
            builder: (_, __) => const PreviewSharePage(),
          ),
        );
      case EDITING_COLLECTION_PAGE:
        final arguments = settings.arguments as Map<String, dynamic>;
        final item = arguments['item'] as MemoryCard;
        final title = arguments['collectionTitle'] as String;
        final imagePath = arguments['localPath'] as String;
        return MaterialPageRoute(
          builder: (context) => Provider<Auth>.value(
            value: auth,
            builder: (_, __) => EditingCollectionPage(
              title: title,
              card: item,
              imagePath: imagePath,
            ),
          ),
        );

      case TEST:
        return MaterialPageRoute(builder: (context) => TestPage());
      default:
        throw PlatformException(code: '404', message: 'Route not found');
    }
  }
}
