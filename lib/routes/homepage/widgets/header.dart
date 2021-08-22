import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lingua_eidetic/widgets/search_box.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.height,
    required this.onQuery,
  }) : super(key: key);
  final double height;
  final ValueChanged<String> onQuery;

  @override
  Widget build(BuildContext context) {
    final auth = Auth();
    final String? urlImage = auth.currentUser?.photoURL;
    String? username = auth.currentUser?.displayName;
    if (username == null || username.trim().isEmpty) {
      username = 'User';
    }
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(
        vertical: defaultPadding * 2,
        horizontal: defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(urlImage ??
                    'https://github.com/hoangvu03081/Lingua-Eidetic/blob/main/assets/images/hacker.png?raw=true'),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                child: Text(
                  'Hi, $username!',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      height: 30,
                      width: 30,
                      child: SvgPicture.asset(
                        'assets/images/community.svg',
                        fit: BoxFit.contain,
                      )),
                ),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding * 2),
          SearchBox(filterFunc: onQuery),
          const SizedBox(height: defaultPadding * 2),
          const Text(
            'Collections',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
