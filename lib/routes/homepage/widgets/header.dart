import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/user_avatar.dart';
import 'package:lingua_eidetic/routes/routes.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lingua_eidetic/widgets/search_box.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.onQuery,
  }) : super(key: key);
  final ValueChanged<String> onQuery;

  @override
  Widget build(BuildContext context) {
    final auth = Auth();
    final String? urlImage = auth.currentUser?.photoURL;
    String? username = auth.currentUser?.displayName;
    if (username == null || username.trim() == '') {
      username = 'User';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            UserAvatar(urlImage: urlImage),
            const SizedBox(width: defaultPadding),
            Expanded(
              child: Text(
                'Hi, $username!',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            PopupMenuButton<int>(
                child: const Icon(
                  Icons.more_horiz,
                  color: Colors.black,
                ),
                itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
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
                      break;
                    case 2:
                      auth.signOut();
                      break;
                    default:
                  }
                }),
          ],
        ),
        const SizedBox(height: defaultPadding * 2),
        SizedBox(
          height: 40,
          child: SearchBox(filterFunc: onQuery),
        ),
      ],
    );
  }
}
