import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:lingua_eidetic/models/memory_card.dart';

class Collection {
  String name;
  Collection({
    required this.name,
  });

  Collection copyWith({
    String? name,
  }) {
    return Collection(
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory Collection.fromMap(Map<String, dynamic> map) {
    return Collection(
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Collection.fromJson(String source) =>
      Collection.fromMap(json.decode(source));

  @override
  String toString() => 'Collection(name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Collection && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
