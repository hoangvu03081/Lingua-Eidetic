import 'package:lingua_eidetic/models/comment.dart';
import 'package:lingua_eidetic/repositories/comment_repository.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lingua_eidetic/services/community_service.dart';

class CommentService {
  final CommunityService communityService = CommunityService();
  final CommentRepository _repository = CommentRepository();
  final Auth _auth = Auth();

  Stream get data =>
      _repository.collectionStream(collectionId: communityService.current);

  Future<void> comment(String content) async {
    String? avatar = _auth.currentUser!.photoURL;
    Comment comment = Comment(
      avatar: avatar ?? "",
      commentDate: DateTime.now(),
      content: content,
    );
    _repository.addComment(
        collectionId: communityService.current, comment: comment);
  }
}
