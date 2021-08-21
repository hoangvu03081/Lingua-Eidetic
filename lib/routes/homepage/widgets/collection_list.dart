import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lingua_eidetic/constants.dart';
import 'package:lingua_eidetic/models/collection.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/collection_card_v2.dart';
import 'package:lingua_eidetic/services/collection_service.dart';

class CollectionList extends StatefulWidget {
  CollectionList({
    Key? key,
    required this.data,
    required this.query,
  }) : super(key: key);
  final String query;
  final Stream<QuerySnapshot<Object?>> data;

  @override
  _CollectionListState createState() => _CollectionListState();
}

class _CollectionListState extends State<CollectionList> {
  final CollectionService collectionService = CollectionService();
  List<Collection> _cached = [];
  List<String> _ids = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.data,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          if (_cached.isEmpty)
            return Center(child: CircularProgressIndicator());
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (_cached[index].name.contains(widget.query))
                return CollectionCardV2(
                  key: Key(_ids[index]),
                  title: _cached[index].name,
                  avail: 5,
                  total: 27,
                  remove: () {
                    collectionService.deleteCollection(
                        collectionId: _ids[index]);
                  },
                );
              return SizedBox();
            },
            itemCount: snapshot.data!.docs.length,
          );
        }

        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            String id = snapshot.data!.docs[index].id;

            Collection item = Collection.fromMap(
                snapshot.data!.docs[index].data() as Map<String, dynamic>);
            if (index == 0) {
              _cached.clear();
              _ids.clear();
            }
            if (!_cached.contains(item)) {
              _cached.add(item);
              _ids.add(id);
            }

            if (item.name.contains(widget.query))
              return CollectionCardV2(
                key: Key(id),
                title: item.name,
                avail: 5,
                total: 27,
                remove: () {
                  collectionService.deleteCollection(collectionId: id);
                },
              );
            return SizedBox();
          },
          itemCount: snapshot.data!.docs.length,
        );
      },
    );
  }
}
