import 'dart:convert';

class Comment {
  String userId;
  String description;
  DateTime commentDate;
  Comment({
    required this.userId,
    required this.description,
    required this.commentDate,
  });

  Comment copyWith({
    String? userId,
    String? description,
    DateTime? commentDate,
  }) {
    return Comment(
      userId: userId ?? this.userId,
      description: description ?? this.description,
      commentDate: commentDate ?? this.commentDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'description': description,
      'commentDate': commentDate.millisecondsSinceEpoch,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      userId: map['userId'],
      description: map['description'],
      commentDate: DateTime.fromMillisecondsSinceEpoch(map['commentDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source));

  @override
  String toString() =>
      'Comment(userId: $userId, description: $description, commentDate: $commentDate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comment &&
        other.userId == userId &&
        other.description == description &&
        other.commentDate == commentDate;
  }

  @override
  int get hashCode =>
      userId.hashCode ^ description.hashCode ^ commentDate.hashCode;
}
