import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lingua_eidetic/models/collection.dart';
import 'package:lingua_eidetic/repositories/card_repository.dart';
import 'package:lingua_eidetic/repositories/collection_repository.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lingua_eidetic/services/card_service.dart';
import 'package:lingua_eidetic/services/image_service.dart';

class CollectionService extends ChangeNotifier {
  final CollectionRepository _collectionRepository = CollectionRepository();
  final CardRepository _cardRepository = CardRepository();

  final ImageService _imageService = ImageService();
  final Auth _auth = Auth();

  late String _currentCollection;

  /// return [String] current selected collection's id.
  String get current => _currentCollection;

  /// return a stream of collection to use in a [StreamBuilder]
  ///
  /// For example:
  /// ```dart
  /// StreamBuilder<QuerySnapshot>(
  ///    stream: collectionService.data,
  ///    builder: (context, snapshot) {
  ///      if (snapshot.hasError) {
  ///        return Text('Something went wrong');
  ///      }
  ///      if (snapshot.connectionState == ConnectionState.waiting) {
  ///        return Text("Loading");
  ///      }
  ///      Iterable<Collection> collection =
  ///         snapshot.data!.docs.map(
  ///      (DocumentSnapshot document) => Collection.fromMap(
  ///      document.data() as Map<String, dynamic>));
  ///        return Text(collection.length.toString());
  ///    },
  ///)
  ///```
  Stream<QuerySnapshot> get data =>
      _collectionRepository.collectionStream(userId: _auth.currentUser!.uid);

  /// set current collection id.
  set current(String collectionId) => _currentCollection = collectionId;

  void addCollection({required String name}) {
    _collectionRepository.addCollection(
        userId: _auth.currentUser!.uid, collection: Collection(name: name));
    notifyListeners();
  }

  void deleteCollection({required String collectionId}) async {
    final cardIdList = await _cardRepository.getInstantCardIdList(
        _auth.currentUser!.uid, collectionId);
    // if (cardIdList != null || cardIdList!.isNotEmpty)
    //   cardIdList.forEach((id) => _imageService.removeImage(id));
    _collectionRepository.removeCollection(
        userId: _auth.currentUser!.uid, collectionId: collectionId);
    notifyListeners();
  }

  Future<int> getAvailableCollectionCount(
      {required String collectionId}) async {
    try {
      final cardList = await _cardRepository.getInstantCardList(
          _auth.currentUser!.uid, collectionId);
      int result = 0;
      final now = DateTime.now();
      for (var card in cardList) {
        if (now.compareTo(card.available) >= 0) ++result;
      }
      return result;
    } catch (e) {
      print(e.toString());
    }
    return 0;
  }

  CollectionService._();

  static final CollectionService _collectionService = CollectionService._();

  ///return a singleton instance of [CollectionService]
  factory CollectionService() {
    return _collectionService;
  }
}
