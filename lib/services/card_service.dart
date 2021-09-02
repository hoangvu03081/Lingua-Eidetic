import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lingua_eidetic/models/memory_card.dart';
import 'package:lingua_eidetic/repositories/card_repository.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lingua_eidetic/services/collection_service.dart';
import 'package:lingua_eidetic/services/image_service.dart';
import 'package:lingua_eidetic/utilities/firestore_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class CardService {
  final ImageService _imageService = ImageService();
  final CollectionService _collectionService = CollectionService();
  final Auth _auth = Auth();
  final CardRepository _cardRepository = CardRepository();

  late String _currentCard;

  ///return [String] current selected card's id.
  String get current => _currentCard;
  set current(String cardId) => _currentCard = cardId;

  /// return a stream of [MemoryCard] to use in a [StreamBuilder]
  Stream<QuerySnapshot> get data => _cardRepository.collectionStream(
      userId: _auth.currentUser!.uid, collectionId: _collectionService.current);

  Future<Iterable<MemoryCard>> getCardList(
      String userId, String collectionId) async {
    final query =
        await _cardRepository.getInstantCardList(userId, collectionId);
    final result =
        query.map((e) => MemoryCard.fromMap(e.data() as Map<String, dynamic>));
    return result;
  }

  Future<List<QueryDocumentSnapshot>> getCardQuery(
      String userId, String collectionId) async {
    final query =
        await _cardRepository.getInstantCardList(userId, collectionId);
    return query;
  }

  Future<List<QueryDocumentSnapshot<Object?>>> get availableCard {
    return _cardRepository.getAvailableCard(
        userId: _auth.currentUser!.uid,
        collectionId: _collectionService.current);
  }

  String image(String id) {
    return '${AppConstant.path}/$id.png';
  }

  ///add a new card to current collection. Use this when collection has a current id.
  void addCard(MemoryCard card, String imagePath) async {
    String cardId = Uuid().v4();
    _cardRepository.addCard(
        userId: _auth.currentUser!.uid,
        collectionId: _collectionService.current,
        cardId: cardId,
        card: card);
    storeImage(
        collectionId: _collectionService.current,
        cardId: cardId,
        imagePath: imagePath);
  }

  void removeCard(String cardId, String collectionId) async {
    _cardRepository.deleteCard(
        userId: _auth.currentUser!.uid,
        collectionId: collectionId,
        cardId: cardId);
    _imageService.removeImage(cardId);
  }

  void updateCardStatus(
      {required String cardId,
      required int level,
      required int exp,
      required int available}) {
    _cardRepository.updateCardStatus(
        userId: _auth.currentUser!.uid,
        collectionId: _collectionService.current,
        cardId: cardId,
        level: level,
        exp: exp,
        available: available);
  }

  /// store image to local storage, then add to upload queue (upload to Cloud Storage).
  void storeImage(
      {required String collectionId,
      required String cardId,
      required String imagePath}) async {
    await File(imagePath).copy('${AppConstant.path}/$cardId.png');
    _imageService.addImageToQueue(collectionId, '$cardId.png');
  }

  /// update card's image path on Cloud Firestore
  void _updateCardImagePath(
      {required String collectionId,
      required String cardId,
      required String imagePath}) {
    cardId = cardId.substring(0, cardId.length - 4);
    _cardRepository.updateImagePath(
        userId: _auth.currentUser!.uid,
        collectionId: collectionId,
        cardId: cardId,
        imagePath: imagePath);
  }

  /// return an image using [cardId],\
  /// this function will first try to find the image on local storage, if the image exists, it return a path to
  /// the image
  /// - if the image does not exist, it will continue to check for next 5 seconds\
  /// - if there still no image on local storage, this function will download the
  /// image from firebase cloud storage\, then wait for the download to finish,
  /// then return the path to the image
  Future<String> getImage({required String cardId}) async {
    for (int i = 0; i < 5; ++i) {
      File file = File(AppConstant.getImage(cardId));
      if (await file.exists()) {
        return AppConstant.getImage(cardId);
      }
      await Future.delayed(const Duration(seconds: 1));
    }
    final card = await _cardRepository.getCard(
        userId: _auth.currentUser!.uid,
        collectionId: _collectionService.current,
        cardId: cardId);
    await downloadImage(cardId: cardId);
    return AppConstant.getImage(cardId);
  }

  Future<void> downloadImage({required String cardId}) async {
    final card = await _cardRepository.getCard(
        userId: _auth.currentUser!.uid,
        collectionId: _collectionService.current,
        cardId: cardId);
    if (card == null) throw ('');
    final networkImage = await http.get(Uri.parse(card.imagePath));
    final file = File(AppConstant.getImage(cardId));

    await file.writeAsBytes(networkImage.bodyBytes);
    return;
  }

  Stream<int> getAvailableCardCount() async* {
    while (true) {
      int count = await _collectionService.getAvailableCollectionCount(
          collectionId: _collectionService.current);
      yield count;
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  void init() {
    _imageService.uploadQueueInit(_updateCardImagePath);
  }

  ///return a singleton instance of [CardService]
  CardService._();
  static final CardService _cardService = CardService._();
  factory CardService() {
    return _cardService;
  }

  void addCardCaption(
      {required String cardId, required List<String> captions}) {
    _cardRepository.updateCardCaption(
        userId: _auth.currentUser!.uid,
        collectionId: _collectionService.current,
        cardId: cardId,
        caption: captions);
  }
}
