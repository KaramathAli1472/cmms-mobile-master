// Copyright (c) 2025 MaintBoard.com. All rights reserved.

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maintboard/core/models/work_order_status/work_order_status_response.dart';
import 'package:maintboard/core/services/category_cache_service.dart';
import 'package:maintboard/core/services/language_cache_service.dart';
import 'package:maintboard/core/services/location_cache_service.dart';
import 'package:maintboard/core/services/login_cache_service.dart';
import 'package:maintboard/core/services/part_cache_service.dart';
import 'package:maintboard/core/services/priority_cache_service.dart';
import 'package:maintboard/core/services/shared_preference_service.dart';
import 'package:maintboard/core/services/auth_service.dart';
import 'package:maintboard/core/services/snackbar_service.dart';
import 'package:maintboard/core/services/user_profile_cache_service.dart';
import 'package:maintboard/core/services/work_order_status_cache_service.dart';
import 'package:maintboard/core/services/work_order_status_service.dart';
import 'package:maintboard/widgets/modal.dart';
import 'package:maintboard/widgets/primary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  final WorkOrderStatusService workOrderStatusService = WorkOrderStatusService();

  bool isLoading = false;
  bool rememberPassword = true;
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedEmail = prefs.getString('email');
    final encryptedPassword = prefs.getString('password');

    if (encryptedEmail != null && encryptedPassword != null) {
      setState(() {
        usernameController.text = _decrypt(encryptedEmail);
        passwordController.text = _decrypt(encryptedPassword);
        rememberPassword = true;
      });
    }
  }

  Future<void> _saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberPassword) {
      await prefs.setString('email', _encrypt(email));
      await prefs.setString('password', _encrypt(password));
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  String _encrypt(String input) {
    const key = 'CDCA122ACCDB8';
    final bytes = utf8.encode(input + key);
    return base64.encode(bytes);
  }

  String _decrypt(String input) {
    const key = 'CDCA122ACCDB8';
    final bytes = base64.decode(input);
    final result = utf8.decode(bytes);
    return result.replaceAll(key, '');
  }

  Future<void> authenticate(BuildContext context) async {
    final email = usernameController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty) {
      SnackbarService.showError('Please enter your email');
      return;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      SnackbarService.showError('Please enter a valid email address');
      return;
    }
    if (password.isEmpty) {
      SnackbarService.showError('Please enter your password');
      return;
    }

    setState(() => isLoading = true);

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        Modal.error(context, 'No Internet Connection');
        return;
      }

      // Firebase login
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final idToken = await userCredential.user?.getIdToken();
      if (idToken != null) {
        await SharedPreferenceService.saveAccessToken(idToken);
      }

      final authResponse = await authService.fetchLoginProfile(queryParams: {
        'firebaseUID': userCredential.user?.uid,
        'rowsPerPage': 1,
        'pageNumber': 0
      });

      await _saveCredentials(email, password);

      // Save SiteID safely (fallback for now)
      await SharedPreferenceService.saveCurrentSiteID(1);

      // Optional FCM registration
      try {
        final messaging = FirebaseMessaging.instance;
        final deviceToken = await messaging.getToken();
        if (deviceToken != null) {
          await authService.registerDeviceToken("android", deviceToken);
        }
      } catch (e) {
        debugPrint('FCM registration failed: $e');
      }

      final List<WorkOrderStatusResponse> orderStatusList =
      await workOrderStatusService.fetchWorkOrderStatuses();

      WorkOrderStatusCacheService().loadStatuses(orderStatusList);
      UserProfileCacheService().loadUserProfile(authResponse);
      await PriorityCacheService().loadPrioritiesFromAssets();
      await CategoryCacheService().loadCategoriesFromService();
      await LocationCacheService().loadLocationsFromService();
      await PartCacheService().loadPartsFromService();
      await LanguageCacheService().loadLanguagesFromService();
      await LoginCacheService().loadLoginsFromService(queryParams: {
        'siteID': 1,
        'rowsPerPage': 100,
        'pageNumber': 0,
        'sort': 'Name_ASC',
      });

      SnackbarService.showSuccess(
          'Welcome back, ${authResponse.contact?.name}!');

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (_) {
      Modal.error(context, 'Authentication failed. Please try again.');
    } catch (e, stackTrace) {
      debugPrint('Auth Error: $e');
      debugPrint('StackTrace: $stackTrace');
      SnackbarService.showError('Something went wrong during login');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/logo.png', height: 100),
              const SizedBox(height: 20),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: rememberPassword,
                    onChanged: (value) {
                      setState(() {
                        rememberPassword = value!;
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        rememberPassword = !rememberPassword;
                      });
                    },
                    child: const Text('Remember Password'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                onPressed: isLoading ? null : () => authenticate(context),
                text: 'Login',
                isLoading: isLoading,
                icon: Icons.arrow_forward,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
