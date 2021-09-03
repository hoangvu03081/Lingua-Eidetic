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

        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          if (_cached.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemBuilder: (context, index) {
              if (index < _cached.length &&
                  _cached[index]
                      .name
                      .toLowerCase()
                      .contains(widget.query.toLowerCase())) {
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
              }
              return const SizedBox();
            },
            itemCount: snapshot.data!.docs.length,
          );
        }

        return ListView.builder(
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
            if (item.name.toLowerCase().contains(widget.query.toLowerCase())) {
              return FutureBuilder(
                builder: (BuildContext context, AsyncSnapshot<int> avail) {
                  return CollectionCardV2(
                    key: Key(id),
                    title: item.name,
                    avail: avail.data!,
                    total: 27,
                    remove: () {
                      collectionService.deleteCollection(collectionId: id);
                    },
                  );
                },
                future: collectionService.getAvailableCollectionCount(
                    collectionId: id),
                initialData: 0,
              );
            }
            return const SizedBox();
          },
          itemCount: snapshot.data!.docs.length,
        );
      },
    );
  }
}
