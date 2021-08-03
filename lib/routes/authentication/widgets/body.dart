import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/auth_card.dart';

class AuthenticationPageBody extends StatelessWidget {
  const AuthenticationPageBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      // singleChildScrollView
      // SizedBox height height
      body: Stack(
        children: [
          // background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.asset(
                'assets/images/sign_in_page.png',
                width: size.width,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // background

          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(
                  top: size.height * 0.1, bottom: defaultPadding * 2),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: size.width * 0.9,
                  child: AuthCard(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
