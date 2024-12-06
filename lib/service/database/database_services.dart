import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_hostel_app/model/user.dart';
import 'package:logger/logger.dart';

class DatabaseServices {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final logger = Logger();

  static const String usersCollection = "users";

  // Save User Info
  Future<void> saveUserInfoIntoFirebase({
    required String name,
    required String email,
    required String regNumber,
    required String program,
    required String phoneNumber,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw FirebaseAuthException(
          code: "user-not-logged-in",
          message: "No user is currently logged in.",
        );
      }

      String uid = currentUser.uid;
      UserProfile user = UserProfile(
          uid: uid,
          name: name,
          email: email,
          regNumber: regNumber,
          phoneNumber: phoneNumber,
          program: program);
      await _db.collection(usersCollection).doc(uid).set(user.toMap());
    } catch (e) {
      logger.e("Error saving user info: $e");
      rethrow;
    }
  }

  // Get User Info
  Future<UserProfile?> getUserFromFirebase(String uid) async {
    if (uid.isEmpty) {
      throw ArgumentError("The UID cannot be empty.");
    }

    try {
      DocumentSnapshot userDoc =
          await _db.collection(usersCollection).doc(uid).get();
      if (userDoc.exists) {
        return UserProfile.fromDocument(userDoc);
      } else {
        logger.w("User not found for UID: $uid");
        return null;
      }
    } catch (e) {
      logger.e("Error retrieving user info: $e");
      return null;
    }
  }
}
