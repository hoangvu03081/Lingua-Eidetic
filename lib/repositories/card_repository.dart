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

  Future<List<QueryDocumentSnapshot<Object?>>> getAvailableCard(
      {required String userId, required String collectionId}) async {
    CollectionReference collectionRef =
        _firestore.collection(CloudPath.card(userId, collectionId));
    final query = await collectionRef
        .where('available',
            isLessThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
        .get();

    final result = query.docs;
    result.removeWhere(
        (element) => (element.data() as Map<String, dynamic>)['level'] > 5);

    return result;
  }

  /// return one time read of all card id in a collection
  Future<Iterable<MemoryCard>> getInstantCardList(
      String userId, String collectionId) async {
    CollectionReference collectionRef =
        _firestore.collection(CloudPath.card(userId, collectionId));
    final query = await collectionRef.get();
    return query.docs
        .map((e) => MemoryCard.fromMap(e.data() as Map<String, dynamic>));
  }

  /// return one time read of a card in a collection
  Future<MemoryCard?> getCard(
      {required String userId,
      required String collectionId,
      required String cardId}) async {
    final DocumentReference docRef =
        _firestore.doc(CloudPath.card(userId, collectionId) + '/$cardId');
    final query = await docRef.get();
    return MemoryCard.fromMap(query.data() as Map<String, dynamic>);
  }

  /// return one time read of all card id in a collection
  Future<Iterable<String>?> getInstantCardIdList(
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

  void addCard({
    required String userId,
    required String collectionId,
    required String cardId,
    required MemoryCard card,
  }) async {
    final docRef =
        _firestore.collection(CloudPath.card(userId, collectionId)).doc(cardId);
    await docRef.set(card.toMap());
  }

  void setCard({
    required String userId,
    required String collectionId,
    required String cardId,
    required MemoryCard card,
  }) {
    CollectionReference collectionRef =
        _firestore.collection(CloudPath.card(userId, collectionId));
    collectionRef.doc(cardId).set(card.toMap());
  }

  void updateCardStatus(
      {required String userId,
      required String collectionId,
      required String cardId,
      required int level,
      required int exp,
      required int available}) {
    final docRef =
        _firestore.collection(CloudPath.card(userId, collectionId)).doc(cardId);
    docRef.update({'level': level, 'exp': exp, 'available': available});
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
