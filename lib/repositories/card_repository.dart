import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingua_eidetic/models/memory_card.dart';
import 'package:lingua_eidetic/utilities/firestore_path.dart';

class CardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> collectionStream(
      {required String userId, required String collectionId}) {
    return _firestore
        .collection(CloudPath.card(userId, collectionId))
        .snapshots();
  }

  /// return one time read of all card in a collection
  Future<Iterable<String>?> oneTimeCardIdList(
      String userId, String collectionId) async {
    CollectionReference collectionRef =
        _firestore.collection(CloudPath.card(userId, collectionId));
    final query = await collectionRef.get();
    final idList = query.docs.map((e) => (e.id));
    return Future.value(idList);
  }

  void deleteCard({
    required String userId,
    required String collectionId,
    required String cardId,
  }) {
    CollectionReference collectionRef =
        _firestore.collection(CloudPath.card(userId, collectionId));
    collectionRef.doc(cardId).delete();
  }

  Future<String> addCard({
    required String userId,
    required String collectionId,
    required MemoryCard card,
  }) async {
    CollectionReference collectionRef =
        _firestore.collection(CloudPath.card(userId, collectionId));
    DocumentReference returnValue = await collectionRef.add(card.toMap());
    return returnValue.id;
  }

  void updateCard({
    required String userId,
    required String collectionId,
    required String cardId,
    required MemoryCard card,
  }) {
    CollectionReference collectionRef =
        _firestore.collection(CloudPath.card(userId, collectionId));
    collectionRef.doc(cardId).set(card.toMap());
  }

  void updateImagePath(
      {required String userId,
      required String collectionId,
      required String cardId,
      required String imagePath}) {
    CollectionReference collectionRef =
        _firestore.collection(CloudPath.card(userId, collectionId));
    collectionRef.doc(cardId).update({'imagePath': imagePath});
  }

  CardRepository._();
  factory CardRepository() {
    return CardRepository._();
  }
}
