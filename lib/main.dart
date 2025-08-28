// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for orientation lock

// Firebase Core and Messaging
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maintboard/core/services/firebase_messaging_service.dart';
import 'package:maintboard/core/services/snackbar_service.dart';

// Project files
import 'ui/screens/auth/auth_screen.dart';
import 'ui/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock the app to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    // Check internet connectivity before Firebase initialization
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      SnackbarService.showError('No internet connection');
    }

    // Initialize Firebase and Notifications
    await Firebase.initializeApp();
    await FirebaseMessagingService.initialize();
  } catch (e) {
    SnackbarService.showError('Error during initialization: $e');
  }

  runApp(
      const ProviderScope(child: MyApp())); // Wrap the app with ProviderScope
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MaintBoard',
      theme: ThemeData(
        useMaterial3: true, // Ensure Material 3 is enabled
        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          titleTextStyle:
              TextStyle(color: Colors.black), // This applies to ListTile titles
          subtitleTextStyle: TextStyle(
              color: Colors.grey), // This applies to ListTile subtitles
        ),

        colorScheme: ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.grey,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.grey[100],
        ),
        iconTheme: IconThemeData(color: Colors.black),
        buttonTheme: ButtonThemeData(buttonColor: Colors.black),

        // Added inputDecorationTheme for consistent text fields and dropdowns
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0), // Global border radius
            borderSide: const BorderSide(
              color: Colors.grey, // Default border color
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.grey, // Unfocused border color
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.black, // Focused border color
              width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.red, // Error border color
              width: 2.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.red, // Focused error color
              width: 2.0,
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false, // Remove the debug banner
      initialRoute: '/',
      routes: {
        '/': (context) => AuthScreen(),
        '/home': (context) => HomeScreen(),
      },
      scaffoldMessengerKey: SnackbarService.scaffoldMessengerKey,
    );
  }
}
