import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingua_eidetic/constants.dart';

class AuthWithGoogleFacebook extends StatelessWidget {
  const AuthWithGoogleFacebook({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}