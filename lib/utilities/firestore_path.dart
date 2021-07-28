/// Provide frequently used path for Cloud Firestore.
class CloudPath {
  static String collection(String userId) => 'user/$userId/collection';
  static String card(String userId, String collectionId) =>
      'user/$userId/collection/$collectionId';
}
