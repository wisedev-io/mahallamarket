import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepo {
  User? get currentUser;
  Future<UserCredential> signInWithEmailPassword(String email, String password);
  Future<void> signOut();
}
