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
import 'package:lingua_eidetic/services/community_service.dart';
import 'package:lingua_eidetic/services/image_service.dart';
import 'package:lingua_eidetic/services/upload_service.dart';
import 'package:lingua_eidetic/utilities/firestore_path.dart';
import 'package:lingua_eidetic/widgets/collection_navbar.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final CollectionService collectionService = CollectionService();
    final ImageService imageService = ImageService();
    final CardService cardService = CardService();
    collectionService.current = 'fXXxLFHUMEwP984OnM4L';
    final UploadService uploadService = UploadService();
    final CommunityService communityService = CommunityService();
    communityService.current = 'fXXxLFHUMEwP984OnM4L';
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
              onPressed: () async {
                final imgPath1 = await cardService.getImage(
                    cardId: '112e9878-c9b9-4921-b744-bdc829deca26');
                final imgPath2 = await cardService.getImage(
                    cardId: '6ce1172d-ef7a-45af-adfc-4c082e8e52b1');
                await uploadService.uploadCollection(
                  name: 'Easy Anatomy',
                  description: 'An Anatomy Collection targeted for beginners',
                  imagePath: [imgPath1, imgPath2],
                );
                // print(temp);
              },
              child: Text('Upload Collection!!!'),
            ),
            ElevatedButton(
                onPressed: () async {
                  final temp = await collectionService.getAllCardId();
                  for (final id in temp) {
                    print(id);
                  }
                },
                child: Text('Print some image path!')),
            ElevatedButton(
              onPressed: () async {
                final imgPath1 = await cardService.getImage(
                    cardId: '6ce1172d-ef7a-45af-adfc-4c082e8e52b1');
                print(imgPath1);
              },
              child: Text('Test some image'),
            ),
            ElevatedButton(
              onPressed: () async {
                final temp = await communityService.getCollection();
                temp.forEach((element) {
                  print(element);
                });
              },
              child: Text('Search!'),
            ),
            ElevatedButton(
              onPressed: () async {
                communityService.downloadCollection();
              },
              child: Text('Test download'),
            ),
            ElevatedButton(
                onPressed: () async {
                  communityService.love();
                },
                child: Text('love')),
            Container(
              width: 300,
              height: 300,
              color: Colors.blue,
              child: Stack(
                children: [
                  Text(
                    'hello',
                    style: TextStyle(
                      fontSize: 50,
                    ),
                  ),
                  Image.network(
                    'https://www.lunapic.com/editor/premade/transparent.gif',
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
