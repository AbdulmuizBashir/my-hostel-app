// room_application.dart
import 'dart:convert';

class RoomApplication {
  final String roomName;
  final String studentId;
  final DateTime applicationDate;
  final String imagePath;
  final double price; // Add price field

  RoomApplication({
    required this.roomName,
    required this.studentId,
    required this.applicationDate,
    required this.imagePath,
    required this.price, // Include price in constructor
  });

  Map<String, dynamic> toJson() {
    return {
      'roomName': roomName,
      'studentId': studentId,
      'applicationDate': applicationDate.toIso8601String(),
      'imagePath': imagePath,
      'price': price, // Add price to JSON
    };
  }

  static RoomApplication fromJson(Map<String, dynamic> json) {
    return RoomApplication(
      roomName: json['roomName'],
      studentId: json['studentId'],
      applicationDate: DateTime.parse(json['applicationDate']),
      imagePath: json['imagePath'],
      price: json['price'], // Parse price
    );
  }
}
