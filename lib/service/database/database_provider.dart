import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_hostel_app/service/auth/auth_service.dart';
import 'package:my_hostel_app/service/database/database_services.dart';
import 'package:my_hostel_app/model/user.dart';

class DatabaseProvider extends ChangeNotifier {
  final _auth = AuthService();
  final _db = DatabaseServices();

  Future<UserProfile?> userprofile(String uid) => _db.getUserFromFirebase(uid);

  Future<void> updateUserProfileField(
      String uid, String field, String value) async {
    await FirebaseFirestore.instance
        .collection(DatabaseServices.usersCollection)
        .doc(uid)
        .update({field: value});
  }
}
