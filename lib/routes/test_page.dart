import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lingua_eidetic/models/collection.dart';
import 'package:lingua_eidetic/models/memory_card.dart';
import 'package:lingua_eidetic/repositories/collection_repository.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lingua_eidetic/services/card_service.dart';
import 'package:lingua_eidetic/services/collection_service.dart';
import 'package:lingua_eidetic/services/image_service.dart';
import 'package:lingua_eidetic/utilities/firestore_path.dart';
import 'package:lingua_eidetic/widgets/collection_navbar.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final CollectionService collectionService = CollectionService();
    final ImageService imageService = ImageService();
    final CardService cardService = CardService();
    collectionService.current = '7F4T7vQ8cWjExB2t3rtA';
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: CollectionNavbar(galleryButtonFunction: () {
        print('click');
      }, cameraButtonFunction: () {
        print('click 2');
      }),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                print(collectionService.data);
              },
              child: Icon(Icons.ac_unit),
            ),
            ElevatedButton(
              onPressed: () {
                print('pressed');
                collectionService.addCollection(name: 'Anatomy');
              },
              child: Text('Add anatomy'),
            ),
            ElevatedButton(
              onPressed: () {
                print('pressed');
                collectionService.deleteCollection(
                    collectionId: '7F4T7vQ8cWjExB2t3rtA');
              },
              child: Text('Delete anatomy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String? temp = await imageService.getImageFromCamera();
                // print(temp);
              },
              child: Text('Get image'),
            ),
            ElevatedButton(
              onPressed: () async {
                imageService.printHive();
              },
              child: Text('Print hive'),
            ),
            ElevatedButton(
              onPressed: () async {
                List<String>? temp = await imageService.getMutlipleImages();
                collectionService.current = '7F4T7vQ8cWjExB2t3rtA';
                temp!.first;
                cardService.addCard(
                    MemoryCard(
                        imagePath: '',
                        caption: ['nothing', 'something'],
                        available: DateTime.now()),
                    temp.first);
              },
              child: Text('Test upload image'),
            ),
            ElevatedButton(
                onPressed: () {
                  cardService.removeCard(
                      "19gV4DwE7T1nLaW2kgU9", CollectionService().current);
                },
                child: Text('Test delete card')),
            SizedBox(
              width: 400,
              height: 400,
              child: StreamBuilder<QuerySnapshot>(
                stream: collectionService.data,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      String id = snapshot.data!.docs[index].id;
                      Collection item = Collection.fromMap(
                          snapshot.data!.docs[index].data()
                              as Map<String, dynamic>);
                      return Container(
                        child: Text(id),
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  );
                },
              ),
            ),
            FutureBuilder(
              builder: (_, snapshot) {
                print(snapshot.data);
                return Text('');
              },
              future:
                  File(AppConstant.getImage('19CdAud9KPFCV6q2MbYM')).exists(),
            ),
            StreamBuilder<int>(
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != 0) {
                    print('not 0');
                    return Text(snapshot.data.toString());
                  }
                }
                return Text('Might be 0');
              },
              stream: cardService.getAvailableCardCount(),
            )
          ],
        ),
      ),
    );
  }
}
