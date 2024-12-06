// room_application_provider.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_hostel_app/model/room_application.dart';

import 'package:shared_preferences/shared_preferences.dart';

class RoomApplicationProvider with ChangeNotifier {
  List<RoomApplication> _applications = [];

  List<RoomApplication> get applications => _applications;

  RoomApplicationProvider() {
    _loadApplications(); // Load applications from local storage on initialization
  }

  Future<void> _loadApplications() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? applicationsJson = prefs.getStringList('applications');

    if (applicationsJson != null) {
      _applications = applicationsJson
          .map((json) => RoomApplication.fromJson(jsonDecode(json)))
          .toList();
      notifyListeners();
    }
  }

  Future<void> _saveApplications() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> applicationsJson =
        _applications.map((app) => jsonEncode(app.toJson())).toList();
    await prefs.setStringList('applications', applicationsJson);
  }

  // room_application_provider.dart
  void applyForRoom(
      String roomName, String studentId, String imagePath, double price) {
    // Add price parameter
    final application = RoomApplication(
      roomName: roomName,
      studentId: studentId,
      applicationDate: DateTime.now(),
      imagePath: imagePath,
      price: price, // Pass the price
    );
    _applications.add(application);
    _saveApplications(); // Save to local storage
    notifyListeners();
  }

  void deleteApplication(String roomName, String studentId) {
    _applications.removeWhere(
        (app) => app.roomName == roomName && app.studentId == studentId);
    _saveApplications(); // Update local storage
    notifyListeners();
  }

  bool hasAppliedForRoom(String roomName, String studentId) {
    return _applications
        .any((app) => app.roomName == roomName && app.studentId == studentId);
  }
}
