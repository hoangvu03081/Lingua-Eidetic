import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/models/collection.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/collection_card_v2.dart';
import 'package:lingua_eidetic/services/collection_service.dart';

class CollectionList extends StatelessWidget {
  CollectionList({Key? key, required this.data}) : super(key: key);
  final Stream<QuerySnapshot<Object?>> data;
  final CollectionService collectionService = CollectionService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: data,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            String id = snapshot.data!.docs[index].id;

            Collection item = Collection.fromMap(
                snapshot.data!.docs[index].data() as Map<String, dynamic>);
            return CollectionCardV2(
              key: Key(id),
              title: item.name,
              avail: 5,
              total: 27,
              remove: () {
                collectionService.deleteCollection(collectionId: id);
              },
            );
          },
          itemCount: snapshot.data!.docs.length,
        );
      },
    );
  }
}
