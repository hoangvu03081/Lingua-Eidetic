import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingua_eidetic/models/collection.dart';
import 'package:lingua_eidetic/utilities/firestore_path.dart';

class CollectionRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addCollection({required String userId, required Collection collection}) {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(CloudPath.collection(userId));
    collectionRef.add(collection.toMap());
  }

  void removeCollection(
      {required String userId, required String collectionId}) {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(CloudPath.collection(userId));
    collectionRef.doc(collectionId).delete();
  }

  Stream<QuerySnapshot> collectionStream({required String userId}) {
    return FirebaseFirestore.instance
        .collection(CloudPath.collection(userId))
        .snapshots();
  }
}
