import 'package:flutter/cupertino.dart';
import 'package:lingua_eidetic/models/collection.dart';
import 'package:lingua_eidetic/repositories/collection_repository.dart';

class CollectionService extends ChangeNotifier {
  final CollectionRepository _collectionRepository;

  CollectionService({
    required CollectionRepository collectionRepository,
  }) : _collectionRepository = collectionRepository;

  late String currentCollection;

  set current(String collectionId) => currentCollection = collectionId;
  void addCollection({required String name}) {
    // _collectionRepository.addCollection(
    //     userId: userId, collection: Collection(name: name));
    notifyListeners();
  }

  void deleteCollection({required String collectionID}) {
    //_collectionRepository.removeCollection(userId: , collectionId: collectionID);
    notifyListeners();
  }
}
