import 'dart:convert';

import 'package:flutter/foundation.dart';

class MemoryCard {
  String imagePath;
  List<String> caption;
  int level;
  int exp;
  DateTime available;
  MemoryCard({
    required this.imagePath,
    required this.caption,
    this.level = 1,
    this.exp = 0,
    required this.available,
  });

  MemoryCard copyWith({
    String? imagePath,
    List<String>? caption,
    int? level,
    int? exp,
    DateTime? available,
  }) {
    return MemoryCard(
      imagePath: imagePath ?? this.imagePath,
      caption: caption ?? this.caption,
      level: level ?? this.level,
      exp: exp ?? this.exp,
      available: available ?? this.available,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'caption': caption,
      'level': level,
      'exp': exp,
      'available': available.millisecondsSinceEpoch,
    };
  }

  factory MemoryCard.fromMap(Map<String, dynamic> map) {
    return MemoryCard(
      imagePath: map['imagePath'],
      caption: List<String>.from(map['caption']),
      level: map['level'],
      exp: map['exp'],
      available: DateTime.fromMillisecondsSinceEpoch(map['available']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MemoryCard.fromJson(String source) =>
      MemoryCard.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MemoryCard(imagePath: $imagePath, caption: $caption, level: $level, exp: $exp, available: $available)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MemoryCard &&
        other.imagePath == imagePath &&
        listEquals(other.caption, caption) &&
        other.level == level &&
        other.exp == exp &&
        other.available == available;
  }

  @override
  int get hashCode {
    return imagePath.hashCode ^
        caption.hashCode ^
        level.hashCode ^
        exp.hashCode ^
        available.hashCode;
  }
}
