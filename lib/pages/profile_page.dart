import 'package:flutter/material.dart';
import 'package:my_hostel_app/component/profile_list_tile.dart';
import 'package:my_hostel_app/service/database/database_provider.dart';
import 'package:my_hostel_app/model/user.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);
  UserProfile? user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    user = await databaseProvider.userprofile(widget.uid);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> editProfileField(String fieldName, String currentValue) async {
    TextEditingController controller =
        TextEditingController(text: currentValue);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit $fieldName"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Enter new $fieldName",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            GestureDetector(
              child: Container(
                height: 30,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black,
                ),
                child: const Center(
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              onTap: () async {
                final newValue = controller.text.trim();
                if (newValue.isNotEmpty) {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    // Update Firestore
                    await databaseProvider.updateUserProfileField(
                      widget.uid,
                      fieldName.toLowerCase(),
                      newValue,
                    );

                    // Update local state
                    setState(() {
                      user = UserProfile(
                        uid: user!.uid,
                        name: fieldName == "Name" ? newValue : user!.name,
                        regNumber: fieldName == "Registration number"
                            ? newValue
                            : user!.regNumber,
                        program:
                            fieldName == "Program" ? newValue : user!.program,
                        email: fieldName == "Email" ? newValue : user!.email,
                        phoneNumber: fieldName == "Phone Number"
                            ? newValue
                            : user!.phoneNumber,
                      );
                      _isLoading = false;
                    });
                    Navigator.pop(context); // Close dialog
                  } catch (e) {
                    setState(() {
                      _isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error updating $fieldName: $e")),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : user != null
                ? Column(
                    children: [
                      const SizedBox(height: 40),
                      Center(
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffE5E5E5),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person_4_rounded,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      //wrapper
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          color: Color(0xffE5E5E5),
                        ),
                        child: Column(
                          children: [
                            ProfileListTile(
                              leadingText: "Name",
                              subtitle: user!.name,
                              onPressed: () =>
                                  editProfileField("Name", user!.name),
                            ),
                            ProfileListTile(
                              leadingText: "Registration number",
                              subtitle: user!.regNumber,
                              onPressed: () => editProfileField(
                                  "Registration number", user!.regNumber),
                            ),
                            ProfileListTile(
                              leadingText: "Program",
                              subtitle: user!.program,
                              onPressed: () =>
                                  editProfileField("Program", user!.program),
                            ),
                            ProfileListTile(
                              leadingText: "Email",
                              subtitle: user!.email,
                              onPressed: () =>
                                  editProfileField("Email", user!.email),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const Text("User not found"),
      ),
    );
  }
}
