import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/auth_with_google_facebook.dart';
import 'package:lingua_eidetic/routes/authentication/widgets/welcome_text.dart';

class AuthenticationPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;
  final double height;
  final Function() onPressNavigate;
  final String navigateSubtitle;
  final String navigateTitle;

  const AuthenticationPage({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.children,
    required this.height,
    required this.onPressNavigate,
    required this.navigateSubtitle,
    required this.navigateTitle,
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
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(
                  top: size.height * 0.3, bottom: defaultPadding * 2),
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
                          Container(
                            margin: EdgeInsets.only(top: defaultPadding * 2),
                            width: double.infinity,
                            child: TextButton(
                              onPressed: onPressNavigate,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(color: Colors.black54),
                                  ),
                                  children: [
                                    // 'Chưa có tài khoản?'
                                    TextSpan(text: navigateSubtitle + '  '),
                                    // 'Đăng ký ngay!'
                                    TextSpan(
                                      text: navigateTitle,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
