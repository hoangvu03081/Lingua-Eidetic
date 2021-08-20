import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingua_eidetic/models/collection.dart';
import 'package:lingua_eidetic/utilities/firestore_path.dart';

class CollectionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addCollection({required String userId, required Collection collection}) {
    CollectionReference collectionRef =
        _firestore.collection(CloudPath.collection(userId));
    collectionRef.add(collection.toMap());
  }

  void removeCollection(
      {required String userId, required String collectionId}) {
    CollectionReference collectionRef =
        _firestore.collection(CloudPath.collection(userId));
    collectionRef.doc(collectionId).delete();
  }

  Stream<QuerySnapshot> collectionStream({required String userId}) {
    return _firestore
        .collection(CloudPath.collection(userId))
        .orderBy('name')
        .snapshots();
  }

  CollectionRepository._();

  static final CollectionRepository _collectionRepository =
      CollectionRepository._();

  ///return a singleton instance of [CollectionRepository]
  factory CollectionRepository() {
    return _collectionRepository;
  }
}
