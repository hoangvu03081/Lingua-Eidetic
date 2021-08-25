import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lingua_eidetic/widgets/search_box.dart';

class Header extends StatefulWidget {
  const Header({
    Key? key,
    required this.height,
    required this.onQuery,
  }) : super(key: key);
  final double height;
  final ValueChanged<String> onQuery;

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool _userActionsOffstage = true;
  @override
  Widget build(BuildContext context) {
    final auth = Auth();
    final String? urlImage = auth.currentUser?.photoURL;
    String? username = auth.currentUser?.displayName;
    if (username == null || username.trim().isEmpty) {
      username = 'User';
    }
    return Container(
      height: widget.height,
      padding: const EdgeInsets.only(
        top: defaultPadding * 3,
        left: defaultPadding,
        right: defaultPadding,
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _userActionsOffstage = !_userActionsOffstage;
                      });
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(urlImage ??
                          'https://github.com/hoangvu03081/Lingua-Eidetic/blob/main/assets/images/hacker.png?raw=true'),
                    ),
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
                  GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: SvgPicture.asset('assets/images/community.svg',
                          fit: BoxFit.contain),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding * 2),
              SearchBox(filterFunc: widget.onQuery),
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
          Positioned(
            top: 40,
            child: Offstage(
              offstage: _userActionsOffstage,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Auth().signOut();
                    },
                    child: const Text(
                      'Sign Out',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
