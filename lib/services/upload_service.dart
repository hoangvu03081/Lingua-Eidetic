import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lingua_eidetic/models/collection.dart';
import 'package:lingua_eidetic/models/memory_card.dart';
import 'package:lingua_eidetic/models/shared_collection.dart';
import 'package:lingua_eidetic/repositories/shared_collection_repository.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:lingua_eidetic/services/card_service.dart';
import 'package:lingua_eidetic/services/collection_service.dart';
import 'package:lingua_eidetic/services/image_service.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class UploadService {
  final CardService _cardService = CardService();
  final CollectionService _collectionService = CollectionService();
  final ImageService _imageService = ImageService();
  final Auth _auth = Auth();
  final SharedCollectionRepository _repository = SharedCollectionRepository();

  Future<bool> uploadCollection(
      {required String name,
      required String description,
      required List<String> imagePath}) async {
    try {
      Future<SharedCollection> uploadSharedCollectionStatus =
          _uploadSharedCollection(name, description, imagePath);
      Future<void> uploadCollectionCardsStatus = _uploadCollectionCards();

      final sharedCollection = await uploadSharedCollectionStatus;
      await uploadCollectionCardsStatus;

      await _indexCollection(sharedCollection);

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<SharedCollection> _uploadSharedCollection(
      String name, String description, List<String> imagePath) async {
    final String userId = _auth.currentUser!.uid;
    final String? userAvatar = _auth.currentUser!.photoURL;
    final String authorName = _auth.currentUser!.displayName ?? "Anonymous";
    final String collectionId = _collectionService.current;

    List<String> cloudImagePath = [];
    for (int i = 0; i < imagePath.length; ++i) {
      File temp = File(imagePath[i]);

      final check = await temp.exists();
      if (!check) throw "Image not exist";

      String path = await _imageService.uploadAbsoluteFilePath(
          imagePath[i], '${Uuid().v4()}.png');
      cloudImagePath.add(path);
    }

    // String? avatarPath = userAvatar != null
    //     ? await _imageService.uploadAbsoluteFilePath(
    //         userAvatar, '${Uuid().v4()}.png')
    //     : null;

    final SharedCollection sharedCollection = SharedCollection(
        name: name,
        author: authorName,
        avatar: userAvatar,
        description: description,
        image: cloudImagePath);

    await _repository.addSharedCollection(
        sharedCollection: sharedCollection, collectionId: collectionId);
    return sharedCollection;
  }

  Future<void> _uploadCollectionCards() async {
    final String userId = _auth.currentUser!.uid;
    final String collectionId = _collectionService.current;

    final cardQuery = await _cardService.getCardQuery(userId, collectionId);
    List<MemoryCard> cardList = [];

    for (QueryDocumentSnapshot card in cardQuery) {
      final imagePath = await _cardService.getImage(cardId: card.id);
      final cloudImagePath = await _imageService.uploadAbsoluteFilePath(
          imagePath, '${Uuid().v4()}.png');

      MemoryCard memoryCard =
          MemoryCard.fromMap(card.data() as Map<String, dynamic>);
      memoryCard.imagePath = cloudImagePath;

      cardList.add(memoryCard);
    }

    await _repository.addCards(cardList: cardList, collectionId: collectionId);
  }

  Future<void> _indexCollection(SharedCollection sharedCollection) async {
    final String collectionId = _collectionService.current;
    final headers = {
      'User-Agent': '-n',
      'Content-Type': 'application/json',
      'Authorization':
          'Basic Zmx1dHRlcl9jbGllbnQ6aVhMJWdpWnVQISNpYzFVMXlsaDdPc0xxRjJKSSUyJTdTa1ZNa3JoeW9uSkQlJiNJQVhQKmNeUCNaOUFO'
    };
    final request = http.Request(
        'POST',
        Uri.parse(
            'https://search-lingua-eidetic-test-asbydmnbxrzlkjcm3ljfetwrd4.ap-southeast-1.es.amazonaws.com/lingua_collection/_create/$collectionId'));
    request.body = sharedCollection.toJson();
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      throw response.reasonPhrase.toString();
    }
  }
}
