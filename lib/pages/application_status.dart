import 'package:flutter/material.dart';
import 'package:my_hostel_app/component/application_list_tile.dart';
import 'package:my_hostel_app/model/user.dart';
import 'package:my_hostel_app/service/room_services.dart/room_application_provider.dart';
import 'package:my_hostel_app/service/database/database_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class ApplicationStatusPage extends StatelessWidget {
  final List<String> appliedRooms;
  final Function(String) onDelete;

  const ApplicationStatusPage({
    super.key,
    required this.appliedRooms,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(
        child: Text("User not logged in."),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Application Status",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Consumer<RoomApplicationProvider>(
            builder: (context, roomApplicationProvider, child) {
              final applications = roomApplicationProvider.applications;

              return applications.isEmpty
                  ? const Center(
                      child: Text(
                        "No room application.",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: applications.length,
                        itemBuilder: (context, index) {
                          final application = applications[index];

                          return Consumer<DatabaseProvider>(
                            builder: (context, databaseProvider, child) {
                              return FutureBuilder(
                                future: databaseProvider
                                    .userprofile(currentUser.uid),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  if (snapshot.hasError || !snapshot.hasData) {
                                    return const Center(
                                      child:
                                          Text("Error loading user profile."),
                                    );
                                  }

                                  final userProfile = snapshot.data;

                                  return Container(
                                    margin: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffE5E5E5),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.asset(
                                                  application.imagePath,
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Text(application.roomName),
                                            const Spacer(),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        "Delete Application",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      ),
                                                      content: const Text(
                                                          "Are you sure you want to delete this application?"),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: const Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        const SizedBox(
                                                            width: 40),
                                                        GestureDetector(
                                                          child: Container(
                                                            height: 30,
                                                            width: 100,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            child: const Center(
                                                              child: Text(
                                                                "Delete",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            onDelete(application
                                                                .roomName);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        const SizedBox(height: 16),
                                        Text("Application Details",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )),
                                        ApplicationListTile(
                                          leadingText: "Name",
                                          trailingText: "${userProfile!.name}",
                                        ),
                                        ApplicationListTile(
                                            leadingText: "Email",
                                            trailingText:
                                                "${userProfile.email}"),
                                        ApplicationListTile(
                                          leadingText: "Reg Number",
                                          trailingText:
                                              "${userProfile.regNumber}",
                                        ),
                                        ApplicationListTile(
                                          leadingText: "Phone Number",
                                          trailingText:
                                              "${userProfile.phoneNumber}",
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
