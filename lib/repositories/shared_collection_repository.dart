import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingua_eidetic/models/memory_card.dart';
import 'package:lingua_eidetic/models/shared_collection.dart';
import 'package:lingua_eidetic/utilities/firestore_path.dart';

class SharedCollectionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSharedCollection(
      {required SharedCollection sharedCollection,
      required String collectionId}) async {
    final sharedCollectionRef =
        _firestore.collection(CloudPath.sharedCollection).doc(collectionId);
    await sharedCollectionRef.set(sharedCollection.toMap());
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getInstantCollection(
      {required String collectionId}) async {
    final sharedCollectionRef =
        _firestore.collection(CloudPath.sharedCollection).doc(collectionId);
    return await sharedCollectionRef.get();
  }

  Future<List<QueryDocumentSnapshot>> getInstantCard(
      {required String collectionId}) async {
    final cardCollection = _firestore
        .collection(CloudPath.sharedCollection)
        .doc(collectionId)
        .collection('cards');

    final query = await cardCollection.get();
    return query.docs;
  }

  Future<void> addCards(
      {required List<MemoryCard> cardList,
      required String collectionId}) async {
    final collectionRef =
        _firestore.collection(CloudPath.sharedCards(collectionId));
    for (int i = 0; i < cardList.length; ++i) {
      collectionRef.add(cardList[i].toMap());
    }
  }

  Future<List<QueryDocumentSnapshot>> getLoveList(
      {required String collectionId}) async {
    final collectionRef = _firestore
        .collection(CloudPath.sharedCollection)
        .doc(collectionId)
        .collection('love');

    final query = await collectionRef.get();
    return query.docs;
  }

  Future<void> changeLoveList(
      {required String collectionId,
      required String userId,
      required bool loveStatus}) async {
    final docRef = _firestore.doc(CloudPath.love(collectionId, userId));
    loveStatus ? docRef.set({}) : docRef.delete();
  }

  SharedCollectionRepository._();
  static final SharedCollectionRepository _sharedCollectionRepository =
      SharedCollectionRepository._();
  factory SharedCollectionRepository() {
    return _sharedCollectionRepository;
  }
}
