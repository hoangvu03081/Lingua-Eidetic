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
            StreamBuilder<QuerySnapshot>(
              stream: cardService.data,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                Iterable<MemoryCard> memoryCard = snapshot.data!.docs.map(
                    (DocumentSnapshot document) => MemoryCard.fromMap(
                        document.data() as Map<String, dynamic>));

                return Text(memoryCard.first.available.toUtc().toString());
              },
            )
          ],
        ),
      ),
    );
  }
}
