// main.dart
import 'package:flutter/material.dart';
import 'package:my_hostel_app/pages/splash_screen.dart';
import 'package:my_hostel_app/service/auth/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_hostel_app/service/database/database_provider.dart';
import 'package:my_hostel_app/service/room_services.dart/room_application_provider.dart';

import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DatabaseProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RoomApplicationProvider(), // Make sure this is included
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
