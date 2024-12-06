import 'package:flutter/material.dart';

class RoomInfoPage extends StatelessWidget {
  final String imagePath;
  final String roomInfo;
  final double price; // Add price parameter
  final String studentId; // Add studentId parameter

  const RoomInfoPage({
    super.key,
    required this.imagePath,
    required this.roomInfo,
    required this.price, // Include price in constructor
    required this.studentId, // Include studentId in constructor
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Room Information",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                roomInfo,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                '₦${price.toStringAsFixed(2)}', // Format price with Naira symbol
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  // Disable the button to prevent multiple taps
                  // Optionally show a loading indicator here

                  Navigator.pop(
                      context, true); // Return true to indicate application
                },
                child: Container(
                  height: 50,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.black,
                  ),
                  child: const Center(
                    child: Text(
                      "Apply Now",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
