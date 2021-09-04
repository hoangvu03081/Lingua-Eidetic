import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lingua_eidetic/models/collection.dart';
import 'package:lingua_eidetic/routes/homepage/widgets/collection_card_v2.dart';
import 'package:lingua_eidetic/services/collection_service.dart';

class CollectionList extends StatefulWidget {
  const CollectionList({
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
  final List<Collection> _cached = [];
  final List<String> _ids = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.data,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.hasData) {
          _cached.clear();
          _ids.clear();

          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            Collection item = Collection.fromMap(
                snapshot.data!.docs[i].data() as Map<String, dynamic>);

            if (item.name.toLowerCase().contains(widget.query.toLowerCase())) {
              _cached.add(item);
              _ids.add(snapshot.data!.docs[i].id);
            }
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              String id = _ids[index];
              Collection item = _cached[index];

              return FutureBuilder<List<int>>(
                builder:
                    (BuildContext context, AsyncSnapshot<List<int>> avail) {
                  if (avail.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (avail.hasData) {
                    return CollectionCardV2(
                      key: Key(id),
                      title: item.name,
                      avail: avail.data![0],
                      total: avail.data![1],
                      remove: () {
                        collectionService.deleteCollection(collectionId: id);
                      },
                    );
                  }
                  return const SizedBox();
                },
                future: Future.wait([
                  collectionService.getAvailableCollectionCount(
                      collectionId: id),
                  collectionService.getCollectionTotalCount(collectionId: id),
                ]),
              );
            },
            itemCount: _cached.length,
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
