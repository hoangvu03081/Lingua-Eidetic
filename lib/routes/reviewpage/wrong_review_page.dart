import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lingua_eidetic/models/memory_card.dart';
import 'package:lingua_eidetic/utilities/firestore_path.dart';

class WrongReviewPage extends StatelessWidget {
  const WrongReviewPage({Key? key, required this.wrong}) : super(key: key);

  final Map<String, dynamic> wrong;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final text = wrong['text'];
    final temp = wrong['card'] as QueryDocumentSnapshot<Object?>;
    final cardId = temp.id;
    final card = MemoryCard.fromMap(temp.data() as Map<String, dynamic>);
    return Scaffold(
      backgroundColor: Color(0xFFEDF2F5),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.063),
            Container(
              width: size.width * 0.73,
              height: size.height * 0.045,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: Color(0xFFFF2358)),
                borderRadius: const BorderRadius.all(Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cancel, color: Color(0xFFFF2358)),
                    const Spacer(),
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Color(0xFFFF2358),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.cancel,
                      color: Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height * 0.032),
            Container(
              height: size.height * 0.44,
              width: size.width * 0.66,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ]),
              child: Image.file(
                File(AppConstant.getImage(cardId)),
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(height: size.height * 0.04),
            Row(
              children: [
                SizedBox(width: size.width * 0.16),
                const Text(
                  'Captions',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF172853),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Container(
              width: size.width * 0.84,
              height: size.height * 0.19,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFA1C4FD),
                    Color(0xFFC2E9FB),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.all(Radius.circular(21)),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(color: Color(0xFF172853)))),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {},
                  child: SizedBox(
                      height: size.height * 0.042,
                      width: size.width * 0.22,
                      child: const Center(
                          child: Icon(Icons.menu, color: Color(0xFF172853)))),
                ),
                SizedBox(
                  width: size.width * 0.04,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF172853)),
                  ),
                  onPressed: () =>
                      Navigator.of(context).pop(ReviewStatus.CONTINUE),
                  child: SizedBox(
                    height: size.height * 0.042,
                    width: size.width * 0.22,
                    child: const Center(
                      child: Text('Next', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
