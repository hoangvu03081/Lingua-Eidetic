import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/routes.dart';
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
    final size = MediaQuery.of(context).size;
    final auth = Auth();
    final String? urlImage = auth.currentUser?.photoURL;
    String? username = auth.currentUser?.displayName;
    if (username == null || username.trim().isEmpty) {
      username = 'User';
    }
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  114 + defaultPadding * 4
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    FutureBuilder(
                      future: Connectivity().checkConnectivity(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (snapshot.hasData) {
                          if (snapshot.data != ConnectivityResult.none) {
                            return CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(urlImage ??
                                  'https://github.com/hoangvu03081/Lingua-Eidetic/blob/main/assets/images/hacker.png?raw=true'),
                            );
                          }
                          return const CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                AssetImage('asset/images/hacker.png'),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                    const SizedBox(width: defaultPadding),
                    Expanded(
                      child: Text(
                        'Hi, $username!',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontSize: 24,
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
                                      height: 20,
                                      width: 20,
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
                                      size: 20,
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
                              Navigator.of(context)
                                  .pushNamed(RouteGenerator.COMMUNITY_PAGE);

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
                height: 40,
                child: SearchBox(filterFunc: onQuery),
              ),
              const SizedBox(height: defaultPadding * 2),
              const SizedBox(
                height: 24,
                child: Text(
                  'Collections',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
