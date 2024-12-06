import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String regNumber;
  final String program;
  final String phoneNumber;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.regNumber,
    required this.program,
    required this.phoneNumber,
  });

  factory UserProfile.fromDocument(DocumentSnapshot doc) {
    return UserProfile(
      uid: doc['uid'],
      name: doc['name'],
      email: doc['email'],
      regNumber: doc['regNumber'],
      program: doc['program'],
      phoneNumber: doc['phoneNumber'],
    );
  }

  // App => Firebase
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      'name': name,
      'email': email,
      'program': program,
      'regNumber': regNumber,
      'phoneNumber': phoneNumber,
    };
  }
}
