// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:maintboard/core/services/auth_service.dart';
import 'package:maintboard/core/services/snackbar_service.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  /// Initialize Firebase Messaging
  static Future<void> initialize() async {
    try {
      // Request notification permissions
      // NotificationSettings settings =
      //     await _firebaseMessaging.requestPermission(
      //   alert: true,
      //   announcement: false,
      //   badge: true,
      //   carPlay: false,
      //   criticalAlert: true,
      //   provisional: false,
      //   sound: true,
      // );

      // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //   print('User granted notification permissions.');
      // } else {
      //   print('User denied notification permissions.');
      // }

      // Handle token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        updateTokenOnServer(newToken);
      });

      // Get the initial token and update it on the server
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await updateTokenOnServer(token);
      }

      // Listen for foreground messages
      // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //   print('Received a message while in the foreground!');
      //   print('Message data: ${message.data}');

      //   if (message.notification != null) {
      //     print('Title: ${message.notification?.title}');
      //     print('Body: ${message.notification?.body}');
      //   }
      // });

      // Setup background notification handler
      setupBackgroundNotificationHandler();
    } catch (e) {
      SnackbarService.showError('Error initializing Firebase Messaging: $e');
    }
  }

  /// Background message handler
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // print('Handling a background message: ${message.messageId}');
    // print('Message data: ${message.data}');

    // if (message.notification != null) {
    //   print('Title: ${message.notification?.title}');
    //   print('Body: ${message.notification?.body}');
    // }
  }

  /// Setup background handler
  static void setupBackgroundNotificationHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Update the token on the server
  static Future<void> updateTokenOnServer(String newToken) async {
    try {
      // Check connectivity before attempting to update the token
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        throw Exception('No internet connection. Cannot update token.');
      }

      // Proceed to update the token
      final AuthService authService = AuthService();
      await authService.registerDeviceToken("android", newToken);
    } catch (e) {
      SnackbarService.showError('Error updating FCM token on server: $e');
    }
  }
}
