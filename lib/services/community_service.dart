import 'dart:convert';

import 'package:lingua_eidetic/models/collection.dart';
import 'package:lingua_eidetic/models/memory_card.dart';
import 'package:lingua_eidetic/models/shared_collection.dart';
import 'package:http/http.dart' as http;
import 'package:lingua_eidetic/repositories/card_repository.dart';
import 'package:lingua_eidetic/repositories/collection_repository.dart';
import 'package:lingua_eidetic/repositories/shared_collection_repository.dart';
import 'package:lingua_eidetic/services/auth_service.dart';
import 'package:uuid/uuid.dart';

class CommunityService {
  final Auth _auth = Auth();
  final CardRepository _cardRepository = CardRepository();
  final CollectionRepository _collectionRepository = CollectionRepository();
  final SharedCollectionRepository _sharedRepository =
      SharedCollectionRepository();

  late String _currentCollection;
  String get current => _currentCollection;
  set current(String value) => _currentCollection = value;

  Future<void> downloadCollection() async {
    final oldId = current;
    final newId = Uuid().v4();
    final query =
        await _sharedRepository.getInstantCollection(collectionId: oldId);
    final sharedCollection =
        SharedCollection.fromMap(query.data() as Map<String, dynamic>);

    final collection = Collection(name: sharedCollection.name);
    _collectionRepository.setCollection(
        userId: _auth.currentUser!.uid, collection: collection, id: newId);

    final List<MemoryCard> cardList = [];
    final cardQuery =
        await _sharedRepository.getInstantCard(collectionId: oldId);

    cardQuery.forEach((snapshot) {
      MemoryCard card =
          MemoryCard.fromMap(snapshot.data() as Map<String, dynamic>);
      card.exp = 0;
      card.level = 1;
      card.available = DateTime.now();
      cardList.add(card);
    });

    cardList.forEach((card) {
      _cardRepository.addCard(
          userId: _auth.currentUser!.uid,
          collectionId: newId,
          cardId: Uuid().v4(),
          card: card);
    });

    sharedCollection.id = oldId;
    increaseDownloadCount(sharedCollection);
  }

  void increaseDownloadCount(SharedCollection collection) async {
    ++collection.download;
    _sharedRepository.addSharedCollection(
        sharedCollection: collection, collectionId: collection.id!);
    _indexCollection(collection);
  }

  void love() async {
    final id = current;

    final query =
        await _sharedRepository.getInstantCollection(collectionId: id);
    final sharedCollection =
        SharedCollection.fromMap(query.data() as Map<String, dynamic>);
    sharedCollection.id = query.id;

    bool isLoved = await isAlreadyLoved(id);

    isLoved ? --sharedCollection.love : ++sharedCollection.love;
    _sharedRepository.addSharedCollection(
        sharedCollection: sharedCollection, collectionId: query.id);
    _indexCollection(sharedCollection);

    _sharedRepository.changeLoveList(
        collectionId: id, userId: _auth.currentUser!.uid, loveStatus: !isLoved);
  }

  Future<bool> isAlreadyLoved(String collectionId) async {
    final loveQuery =
        await _sharedRepository.getLoveList(collectionId: collectionId);
    for (int i = 0; i < loveQuery.length; ++i) {
      if (_auth.currentUser!.uid == loveQuery[i].id) return true;
    }
    return false;
  }

  Future<void> _indexCollection(SharedCollection sharedCollection) async {
    final headers = {
      'User-Agent': '-n',
      'Content-Type': 'application/json',
      'Authorization':
          'Basic Zmx1dHRlcl9jbGllbnQ6aVhMJWdpWnVQISNpYzFVMXlsaDdPc0xxRjJKSSUyJTdTa1ZNa3JoeW9uSkQlJiNJQVhQKmNeUCNaOUFO'
    };
    final request = http.Request(
        'PUT',
        Uri.parse(
            'https://search-lingua-eidetic-test-asbydmnbxrzlkjcm3ljfetwrd4.ap-southeast-1.es.amazonaws.com/lingua_collection/_doc/${sharedCollection.id}'));
    request.body = sharedCollection.toJson();
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      throw response.reasonPhrase.toString();
    }
  }

  Future<List<SharedCollection>> search(String query) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Basic Zmx1dHRlcl9jbGllbnQ6aVhMJWdpWnVQISNpYzFVMXlsaDdPc0xxRjJKSSUyJTdTa1ZNa3JoeW9uSkQlJiNJQVhQKmNeUCNaOUFO'
    };

    final request = http.Request(
        'GET',
        Uri.parse(
            'https://search-lingua-eidetic-test-asbydmnbxrzlkjcm3ljfetwrd4.ap-southeast-1.es.amazonaws.com/lingua_collection/_search'));
    request.body =
        '{"query": {"multi_match": {"query": "$query","fields": ["name^2","author","description"]}}}';

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return _convertElasticSearchQuery(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
      print(response.statusCode);
    }
    return [];
  }

  Future<List<SharedCollection>> getCollection() async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Basic Zmx1dHRlcl9jbGllbnQ6aVhMJWdpWnVQISNpYzFVMXlsaDdPc0xxRjJKSSUyJTdTa1ZNa3JoeW9uSkQlJiNJQVhQKmNeUCNaOUFO'
    };

    final request = http.Request(
        'GET',
        Uri.parse(
            'https://search-lingua-eidetic-test-asbydmnbxrzlkjcm3ljfetwrd4.ap-southeast-1.es.amazonaws.com/lingua_collection/_search'));
    request.body = '{"sort": [{"download": "desc"},{"love": "desc"}]}';

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return _convertElasticSearchQuery(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
      print(response.statusCode);
    }
    return [];
  }

  List<SharedCollection> _convertElasticSearchQuery(String response) {
    List<SharedCollection> result = [];
    List<dynamic> resp = jsonDecode(response)['hits']['hits'];

    for (Map<String, dynamic> doc in resp) {
      final collection = SharedCollection.fromMap(doc['_source']);
      collection.id = doc['_id'];
      result.add(collection);
    }

    return result;
  }

  CommunityService._();
  static final CommunityService _communityService = CommunityService._();
  factory CommunityService() {
    return _communityService;
  }
}
