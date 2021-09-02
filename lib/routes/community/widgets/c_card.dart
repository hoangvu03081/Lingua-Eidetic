import 'package:flutter/material.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/text_badge.dart';
import 'package:lingua_eidetic/services/auth_service.dart';

class CCard extends StatelessWidget {
  const CCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
          color: Color(0xFFE9ECFC),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black.withOpacity(0.25),
              offset: Offset(0, 4),
            ),
          ]),
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                children: const [
                  Text(
                    'Anatomy',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(width: defaultPadding),
                  TextBadge(
                    text: 'Editor Choice',
                    textColor: Colors.white,
                    backColor: Color(0xFF172853),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding * 2),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.red,
                  ),
                  const SizedBox(width: defaultPadding),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Oniichan'),
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
              children: const [
                Text('21k'),
                Icon(Icons.favorite_border_outlined),
                Text('52k'),
                Icon(Icons.arrow_downward),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
