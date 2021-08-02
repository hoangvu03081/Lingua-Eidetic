import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleUser = GoogleSignIn();
  final _facebookAuth = FacebookAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<User?> signInWithMailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  Future<User?> signInWithGoogle() async {
    // Trigger the authentication flow
    final googleUser = await _googleUser.signIn();

    // Obtain the auth details from the request
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        return userCredential.user;
      } else {
        throw FirebaseAuthException(code: 'missing-google-id-token');
      }
    } else {
      throw FirebaseAuthException(code: 'sign-in-aborted-by-user');
    }
  }

  Future<User?> signInWithFacebook() async {
    final LoginResult result = await _facebookAuth.login();
    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      final facebookAuthCredential =
          FacebookAuthProvider.credential(accessToken.token);
      final userCredential = await _firebaseAuth.signInWithCredential(
          FacebookAuthProvider.credential(accessToken.token));
      return userCredential.user;
    } else {
      throw FirebaseAuthException(code: 'sign-in-aborted-by-user');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _googleUser.signOut();
  }

  Auth._();
  static final Auth _auth = Auth._();

  ///return a singleton instance of [Auth]
  factory Auth() {
    return _auth;
  }
}
