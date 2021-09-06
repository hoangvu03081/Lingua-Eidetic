import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key? key,
    this.urlImage,
  }) : super(key: key);
  final String? urlImage;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
            backgroundImage: AssetImage('asset/images/hacker.png'),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
