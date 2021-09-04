import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/models/shared_collection.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/text_badge.dart';
import 'package:lingua_eidetic/services/auth_service.dart';

class CCard extends StatelessWidget {
  const CCard({Key? key, required this.collection}) : super(key: key);
  final SharedCollection collection;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
          color: const Color(0xFFE9ECFC),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(0, 4),
            ),
          ]),
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Text(
                    collection.name,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(width: defaultPadding),
                ],
              ),
              const SizedBox(height: defaultPadding * 2),
              Row(
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
                            backgroundImage: NetworkImage(collection.avatar ??
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(collection.author.isEmpty
                          ? 'Anonymous'
                          : collection.author),
                      const SizedBox(height: defaultPadding / 2),
                      Container(
                        width: 35,
                        height: 8,
                        decoration: BoxDecoration(
                            color: const Color(0xFFC4C4C4),
                            borderRadius: BorderRadius.circular(4)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: defaultPadding,
            right: 0,
            child: Row(
              children: [
                Text('${collection.love}'),
                const Icon(Icons.favorite_border_outlined),
                Text('${collection.download}'),
                const Icon(Icons.arrow_downward),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
