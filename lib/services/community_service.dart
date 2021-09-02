import 'dart:convert';

import 'package:lingua_eidetic/models/shared_collection.dart';
import 'package:http/http.dart' as http;

class CommunityService {
  late String _currentCollection;
  String get current => _currentCollection;
  set current(String value) => _currentCollection = value;
  //TODO: receive data, download, comments, love

  Future<void> downloadCollection({required String collectionId}) async {}

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
      return convertElasticSearchQuery(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
      print(response.statusCode);
    }
    return [];
  }

  List<SharedCollection> convertElasticSearchQuery(String response) {
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
