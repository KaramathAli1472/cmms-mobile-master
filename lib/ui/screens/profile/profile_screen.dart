// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:flutter/material.dart';
import 'package:maintboard/widgets/modal.dart';
import 'profile_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileViewModel _viewModel = ProfileViewModel();

  void _logoutConfirmation() {
    Modal.confirm(
      context,
      'Are you sure you want to logout?',
      () {
        _viewModel.logout();
        Navigator.of(context).pop(); // Close the profile screen
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Profile"),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _viewModel.profilePictureUrl.isNotEmpty
                  ? NetworkImage(_viewModel.profilePictureUrl)
                  : null,
              child: _viewModel.profilePictureUrl.isEmpty
                  ? Icon(Icons.person, size: 50)
                  : null,
            ),
            SizedBox(height: 20),
            Text(
              _viewModel.userName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            Text(
              _viewModel.email,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _logoutConfirmation,
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
