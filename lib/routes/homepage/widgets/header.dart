import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingua_eidetic/constants.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.urlImage,
    required this.username,
  }) : super(key: key);
  final String urlImage;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: defaultPadding * 2,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              urlImage,
              width: 50,
            ),
          ),
          SizedBox(width: defaultPadding),
          Expanded(
            child: Text(
              'Hi, $username!',
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset('assets/images/more2_vert.svg'),
            ),
          ),
        ],
      ),
    );
  }
}
