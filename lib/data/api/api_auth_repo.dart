import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repos/auth_repo.dart';

class ApiAuthRepo implements AuthRepo {
  @override
  User? get currentUser => null;

  @override
  Future<UserCredential> signInWithEmailPassword(String email, String password) {
    throw UnimplementedError('Use your API login later');
  }

  @override
  Future<void> signOut() async {}
}
