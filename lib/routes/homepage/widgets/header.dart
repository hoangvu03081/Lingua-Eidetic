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
    final size = MediaQuery.of(context).size;
    final auth = Auth();
    final String? urlImage = auth.currentUser?.photoURL;
    String? username = auth.currentUser?.displayName;
    if (username == null || username.trim().isEmpty) {
      username = 'User';
    }
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.1,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _userActionsOffstage = !_userActionsOffstage;
                        });
                      },
                      child: CircleAvatar(
                        radius: 20,
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
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    PopupMenuButton<int>(
                        child: const Icon(
                          Icons.more_horiz,
                          color: Colors.black,
                        ),
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuItem<int>>[
                              PopupMenuItem<int>(
                                value: 1,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 28,
                                      width: 28,
                                      child: SvgPicture.asset(
                                          'assets/images/community.svg',
                                          fit: BoxFit.contain),
                                    ),
                                    const SizedBox(width: defaultPadding),
                                    const Text('Community'),
                                  ],
                                ),
                              ),
                              PopupMenuItem<int>(
                                value: 2,
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.logout,
                                      size: 28,
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: defaultPadding),
                                    Text('Sign out'),
                                  ],
                                ),
                              ),
                            ],
                        onSelected: (int value) {
                          switch (value) {
                            case 1:

                              /// TODO: COMMUNITY HERE
                              break;
                            case 2:
                              auth.signOut();
                              break;
                            default:
                          }
                        }),
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding * 2),
              SizedBox(
                height: size.height * 0.04 + defaultPadding * 3,
                child: SearchBox(filterFunc: widget.onQuery),
              ),
              const SizedBox(height: defaultPadding * 2),
              SizedBox(
                height: size.height * 0.08,
                child: const Text(
                  'Collections',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
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
                    child: Text(
                      'Sign Out',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: size.height * 0.04,
                      ),
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
