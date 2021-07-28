import 'package:flutter/material.dart';
import 'package:lingua_eidetic/models/collection.dart';
import 'package:lingua_eidetic/repositories/collection_repository.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CollectionRepository collectionRepository = CollectionRepository();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                collectionRepository.removeCollection(
                    userId: 'd0kCArsI34gIZ7guhVxg',
                    collectionId: 'DT8UaohjuFcFFroIxdU6');
              },
              child: Icon(Icons.ac_unit))
        ],
      ),
    );
  }
}
