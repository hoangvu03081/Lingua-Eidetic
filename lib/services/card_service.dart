import 'dart:io';

import 'package:lingua_eidetic/models/memory_card.dart';
import 'package:lingua_eidetic/repositories/card_repository.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lingua_eidetic/services/collection_service.dart';
import 'package:lingua_eidetic/services/image_service.dart';
import 'package:lingua_eidetic/utilities/firestore_path.dart';
import 'package:path_provider/path_provider.dart';

class CardService {
  final ImageService _imageService = ImageService();
  final CollectionService _collectionService = CollectionService();
  final Auth _auth = Auth();
  final CardRepository _cardRepository = CardRepository();

  String image(String id) {
    return '${AppConstant.path}/$id.png';
  }

  ///add a new card to current collection. Use this when collection has a current id.
  void addCard(MemoryCard card, String imagePath) async {
    String cardId = await _cardRepository.addCard(
        userId: _auth.currentUser!.uid,
        collectionId: _collectionService.current,
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

  void editCard() {}

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

  void init() {
    _imageService.uploadQueueInit(_updateCardImagePath);
  }

  ///return a singleton instance of [CardService]
  CardService._();
  static final CardService _cardService = CardService._();
  factory CardService() {
    return _cardService;
  }
}
