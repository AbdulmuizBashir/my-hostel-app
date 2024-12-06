import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  // Get user
  User? getCurrentUser() => _auth.currentUser;

  String getCurrentUid() {
    if (_auth.currentUser != null) {
      return _auth.currentUser!.uid; // Ensure this does not return null
    } else {
      throw Exception("No user is logged in.");
    }
  }

  // Login => email & password
  Future<UserCredential> loginEmailPassword(
    String email,
    String password,
  ) async {
    // Attempt to login
    try {
      final UserCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserCredential;
    }
    // Catch the error
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Register => email & password
  Future<UserCredential> registerEmailAndPassword(
      String email, String password) async {
    try {
      // Attempt to register new user
      final UserCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserCredential;
    }
    // Catch the error
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
