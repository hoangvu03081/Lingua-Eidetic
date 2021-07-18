import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/AuthWithGoogleFacebook.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/welcome_text.dart';

class AuthenticationPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;
  final double height;

  const AuthenticationPage(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.children,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      body: SingleChildScrollView(
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              Image.asset(
                'assets/images/sign_in_page.png',
                width: size.width,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                top: 200,
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: size.width * 0.9,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: defaultPadding * 8,
                          bottom: defaultPadding * 4,
                          left: defaultPadding * 4,
                          right: defaultPadding * 4,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WelcomeText(
                              title: title,
                              subtitle: subtitle,
                            ),
                            SizedBox(height: 60),
                            ...children,
                            SizedBox(height: defaultPadding * 2),
                            AuthWithGoogleFacebook(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
