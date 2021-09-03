import 'dart:convert';

class Comment {
  String? userId;
  String? avatar;
  String content;
  DateTime commentDate;
  Comment({
    required this.avatar,
    required this.content,
    required this.commentDate,
  });

  Comment copyWith({
    String? avatar,
    String? content,
    DateTime? commentDate,
  }) {
    return Comment(
      avatar: avatar ?? this.avatar,
      content: content ?? this.content,
      commentDate: commentDate ?? this.commentDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'avatar': avatar,
      'content': content,
      'commentDate': commentDate.millisecondsSinceEpoch,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      avatar: map['avatar'],
      content: map['content'],
      commentDate: DateTime.fromMillisecondsSinceEpoch(map['commentDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source));

  @override
  String toString() =>
      'Comment(avatar: $avatar, content: $content, commentDate: $commentDate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comment &&
        other.avatar == avatar &&
        other.content == content &&
        other.commentDate == commentDate;
  }

  @override
  int get hashCode => avatar.hashCode ^ content.hashCode ^ commentDate.hashCode;
}
