import 'dart:convert';

import 'package:flutter/foundation.dart';

class SharedCollection {
  String? id;
  String name;
  String author;
  String? avatar;
  String description;
  int love;
  int download;
  List<String> image;
  SharedCollection({
    required this.name,
    required this.author,
    this.avatar,
    required this.description,
    this.love = 0,
    this.download = 0,
    required this.image,
  });

  SharedCollection copyWith({
    String? name,
    String? author,
    String? avatar,
    String? description,
    int? love,
    int? download,
    List<String>? image,
  }) {
    return SharedCollection(
      name: name ?? this.name,
      author: author ?? this.author,
      avatar: avatar ?? this.avatar,
      description: description ?? this.description,
      love: love ?? this.love,
      download: download ?? this.download,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'author': author,
      'avatar': avatar,
      'description': description,
      'love': love,
      'download': download,
      'image': image,
    };
  }

  factory SharedCollection.fromMap(Map<String, dynamic> map) {
    return SharedCollection(
      name: map['name'],
      author: map['author'],
      avatar: map['avatar'],
      description: map['description'],
      love: map['love'],
      download: map['download'],
      image: List<String>.from(map['image']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SharedCollection.fromJson(String source) =>
      SharedCollection.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SharedCollection(name: $name, author: $author, avatar: $avatar, description: $description, love: $love, download: $download, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SharedCollection &&
        other.name == name &&
        other.author == author &&
        other.avatar == avatar &&
        other.description == description &&
        other.love == love &&
        other.download == download &&
        listEquals(other.image, image);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        author.hashCode ^
        avatar.hashCode ^
        description.hashCode ^
        love.hashCode ^
        download.hashCode ^
        image.hashCode;
  }
}
