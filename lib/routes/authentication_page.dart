import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingua_eidetic/constants.dart';

class AuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 800,
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
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Welcome,\n',
                                    style: TextStyle(
                                      fontFamily: 'Yantramanav',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Sign in to continue!',
                                    style: TextStyle(
                                      fontFamily: 'Yantramanav',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 28,
                                      color: Color(0xFFC6C6C6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 60),
                            TextField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: defaultPadding * 2.5,
                                    horizontal: defaultPadding * 3),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFE4E4E4),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF2358),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                labelText: 'Email ID',
                                labelStyle: TextStyle(
                                  color: Color(0xFFBDBCBC),
                                  fontFamily: 'Yantramanav',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: defaultPadding * 2),
                            TextField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: defaultPadding * 2.5,
                                    horizontal: defaultPadding * 3),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFE4E4E4),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF2358),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: Color(0xFFBDBCBC),
                                  fontFamily: 'Yantramanav',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(height: 40),
                            InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {},
                              overlayColor:
                                  MaterialStateProperty.all(Color(0xFF891212)),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                  left: defaultPadding * 2,
                                  right: defaultPadding * 2,
                                  bottom: defaultPadding * 1.5,
                                  top: defaultPadding * 1.2,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFFE4E4E4),
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    stops: [0, 0.6],
                                    colors: [
                                      Color(0xDAFF2358),
                                      Color(0xDAFF5B27),
                                    ],
                                  ),
                                ),
                                child: Text(
                                  'LOGIN',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: defaultPadding * 2),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFF0C3A7E),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          width: 1,
                                          color: Color(0xFF0C3A7E),
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: defaultPadding * 2),
                                      child: SvgPicture.asset(
                                        'assets/images/facebook-square-brands.svg',
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: defaultPadding * 3),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          width: 1,
                                          color: Color(0x66000000),
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: defaultPadding * 2),
                                      child: SvgPicture.asset(
                                        'assets/images/google.svg',
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
