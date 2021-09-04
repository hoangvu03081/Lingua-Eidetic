import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingua_eidetic/models/comment.dart';
import 'package:lingua_eidetic/utilities/firestore_path.dart';

class CommentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> collectionStream({required String collectionId}) {
    return _firestore.collection(CloudPath.comment(collectionId)).snapshots();
  }

  Future<void> addComment(
      {required String collectionId, required Comment comment}) async {
    final docRef = _firestore.collection(CloudPath.comment(collectionId));
    await docRef.add(comment.toMap());
  }
}
