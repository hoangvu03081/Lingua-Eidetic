import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lingua_eidetic/routes/auth/auth_page.dart';
import 'package:lingua_eidetic/routes/auth/startup_animation.dart';
import 'package:lingua_eidetic/routes/homepage/homepage_v2.dart';
import 'package:lingua_eidetic/routes/routes.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lingua_eidetic/services/collection_service.dart';
import 'package:lingua_eidetic/widgets/collection_navbar.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);
  static bool startupAnimation = false;

  @override
  Widget build(BuildContext context) {
    final authService = Auth();
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: authService.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data == null) {
              return !startupAnimation ? StartupAnimation() : AuthPage();
            }
            startupAnimation = true;
            return HomePageV2();
          }
          return const SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
