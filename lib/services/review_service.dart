import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:lingua_eidetic/models/memory_card.dart';
import 'package:lingua_eidetic/services/card_service.dart';
import 'package:lingua_eidetic/utilities/firestore_path.dart';

class LevelSystem {
  final int level;
  final Duration cooldown;
  final int maxExp;
  const LevelSystem({
    required this.level,
    required this.cooldown,
    required this.maxExp,
  });

  LevelSystem copyWith({
    int? level,
    Duration? cooldown,
    int? maxExp,
  }) {
    return LevelSystem(
      level: level ?? this.level,
      cooldown: cooldown ?? this.cooldown,
      maxExp: maxExp ?? this.maxExp,
    );
  }

  @override
  String toString() =>
      'LevelSystem(level: $level, cooldown: $cooldown, maxExp: $maxExp)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LevelSystem &&
        other.level == level &&
        other.cooldown == cooldown &&
        other.maxExp == maxExp;
  }

  @override
  int get hashCode => level.hashCode ^ cooldown.hashCode ^ maxExp.hashCode;
}

class ReviewService extends ChangeNotifier {
  final CardService _cardService = CardService();
  late Future<List<QueryDocumentSnapshot<Object?>>> data =
      _cardService.availableCard;

  final Map<int, LevelSystem> levelSystem = {
    1: const LevelSystem(level: 1, cooldown: Duration(hours: 3), maxExp: 5),
    2: const LevelSystem(level: 2, cooldown: Duration(hours: 6), maxExp: 4),
    3: const LevelSystem(level: 3, cooldown: Duration(hours: 12), maxExp: 3),
    4: const LevelSystem(level: 4, cooldown: Duration(hours: 24), maxExp: 2),
    5: const LevelSystem(level: 5, cooldown: Duration(hours: 48), maxExp: 1),
  };

  late int size;
  int current = 0;

  void updateCurrent(int value) {
    current = value;
    notifyListeners();
  }

  String currentImage(String imageName) => AppConstant.path + '/$imageName.png';

  bool checkCorrect(
      {required String input, required QueryDocumentSnapshot memoryCard}) {
    input = input.toLowerCase();
    MemoryCard card =
        MemoryCard.fromMap(memoryCard.data() as Map<String, dynamic>);
    for (var text in card.caption) {
      if (text.toLowerCase().trim() == input) {
        updateCorrectCard(id: memoryCard.id, memoryCard: card);
        return true;
      }
    }
    return false;
  }

  void updateCorrectCard(
      {required String id, required MemoryCard memoryCard}) async {
    if (memoryCard.exp == levelSystem[memoryCard.level]!.maxExp - 1) {
      _cardService.updateCard(
          cardId: id,
          level: memoryCard.level + 1,
          exp: 0,
          available: DateTime.now()
              .add(levelSystem[memoryCard.level]!.cooldown * 2)
              .millisecondsSinceEpoch);
    } else {
      _cardService.updateCard(
          cardId: id,
          level: memoryCard.level,
          exp: memoryCard.exp + 1,
          available: DateTime.now()
              .add(levelSystem[memoryCard.level]!.cooldown)
              .millisecondsSinceEpoch);
    }
  }

  void updateWrongCard({required QueryDocumentSnapshot memoryCard}) {
    MemoryCard card =
        MemoryCard.fromMap(memoryCard.data() as Map<String, dynamic>);
    _cardService.updateCard(
        cardId: memoryCard.id,
        level: card.level,
        exp: 0,
        available: DateTime.now()
            .add(levelSystem[card.level]!.cooldown * (1 / 2))
            .millisecondsSinceEpoch);
  }
  //TODO: Test review service

  void addCaptionWrongCard(
      {required QueryDocumentSnapshot memoryCard, required String text}) {}
}
