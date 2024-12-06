import 'package:flutter/material.dart';
import 'package:my_hostel_app/component/available_room.dart';
import 'package:my_hostel_app/pages/application_status.dart';
import 'package:my_hostel_app/pages/profile_page.dart';
import 'package:my_hostel_app/pages/room_info_page.dart';
import 'package:my_hostel_app/service/auth/auth_service.dart';
import 'package:my_hostel_app/service/room_services.dart/room_application_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = AuthService();
  int _selectedIndex = 0;

  final List<bool> _isRoomApplied = [false, false, false];
  List<String> _appliedRooms = [];
  final List<double> _roomPrices = [
    60000.00, // Price for Room 1
    40000.00, // Price for Room 2
    20000.00, // Price for Room 3
  ];

  final List<String> _roomDescriptions = [
    "Cozy Double Room for Boys: Ideal for Friends or Roommates. Enjoy a Shared Bathroom and a Comfortable Living Space, Perfect for Relaxing After a Long Day.",
    "Spacious Triple Room for Boys: Perfect for Small Groups. Features Bunk Beds, a Shared Bathroom, and Access to a Communal Kitchenette for Preparing Meals Together.",
    "Vibrant Quadruple Room for Boys: Designed for Groups of Friends or Backpackers. Equipped with Bunk Beds, a Shared Bathroom, and a Lively Common Area for Socializing and Bonding.",
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load saved user data on initialization
  }

  void logout() async {
    await _auth.logout();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _appliedRooms = prefs.getStringList('appliedRooms') ?? [];
      for (int i = 0; i < _isRoomApplied.length; i++) {
        _isRoomApplied[i] = _appliedRooms.contains("Room ${i + 1}");
      }
    });
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('appliedRooms', _appliedRooms);
  }

  Future<void> _navigateToRoomInfo(int roomIndex, String roomName) async {
    if (_appliedRooms.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 1),
        content: const Text(
          'You can only apply for one room at a time. Please delete your existing application first.',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
      return;
    }

    final applied = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomInfoPage(
          imagePath: (roomIndex == 0)
              ? "assets/room_1.jpg"
              : (roomIndex == 1)
                  ? "assets/room_2.jpg"
                  : "assets/room_3.jpg",
          roomInfo: _roomDescriptions[roomIndex],
          price: _roomPrices[roomIndex], // Pass the price here
          studentId: _auth.getCurrentUid(), // Pass the student ID here
        ),
      ),
    );
    if (applied == true) {
      final roomApplicationProvider =
          Provider.of<RoomApplicationProvider>(context, listen: false);
      roomApplicationProvider.applyForRoom(
          "Room ${roomIndex + 1}",
          _auth.getCurrentUid(),
          (roomIndex == 0)
              ? "assets/room_1.jpg"
              : (roomIndex == 1)
                  ? "assets/room_2.jpg"
                  : "assets/room_3.jpg",
          _roomPrices[roomIndex]);

      setState(() {
        _isRoomApplied[roomIndex] = true;
        _appliedRooms.add("Room ${roomIndex + 1}");
        _saveUserData();
      });

      // Show a Snackbar message after applying
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Application submitted successfully! Check your Application Status',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _deleteApplication(String roomName) {
    final roomApplicationProvider =
        Provider.of<RoomApplicationProvider>(context, listen: false);
    roomApplicationProvider.deleteApplication(roomName, _auth.getCurrentUid());

    setState(() {
      _appliedRooms.remove(roomName); // Remove from local list
      for (int i = 0; i < _isRoomApplied.length; i++) {
        if (roomName == "Room ${i + 1}") {
          _isRoomApplied[i] = false; // Update application status
        }
      }
      _saveUserData(); // Update saved data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5E5E5),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          uid: _auth.getCurrentUid(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade400,
                    ),
                    child: const Center(
                      child: Icon(Icons.person_4_rounded),
                    ),
                  ),
                ),
                const Text(
                  "My Hostel",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: logout,
                  child: Container(
                    height: 30,
                    width: 70,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.black,
                    ),
                    child: const Center(
                      child: Text(
                        "Logout",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              "Available Rooms",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            AvailableRoom(
              imagePath: "assets/room_1.jpg",
              price: "₦60,000.00",
              onTap: _isRoomApplied[0]
                  ? null
                  : () => _navigateToRoomInfo(0, "Room 1"),
              isApplied: _isRoomApplied[0],
            ),
            const SizedBox(height: 20),
            AvailableRoom(
              price: "₦40,000.00",
              imagePath: "assets/room_2.jpg",
              onTap: _isRoomApplied[1]
                  ? null
                  : () => _navigateToRoomInfo(1, "Room 2"),
              isApplied: _isRoomApplied[1],
            ),
            const SizedBox(height: 20),
            AvailableRoom(
              price: "₦20,000.00",
              imagePath: "assets/room_3.jpg",
              onTap: _isRoomApplied[2]
                  ? null
                  : () => _navigateToRoomInfo(2, "Room 3"),
              isApplied: _isRoomApplied[2],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        backgroundColor: Color(0xffE5E5E5),
        unselectedItemColor: Colors.black54,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Application Status',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApplicationStatusPage(
                  appliedRooms: _appliedRooms,
                  onDelete: _deleteApplication,
                ),
              ),
            );
          } else {
            _onItemTapped(index);
          }
        },
      ),
    );
  }
}
