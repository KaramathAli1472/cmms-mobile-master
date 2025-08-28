// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maintboard/core/services/shared_preference_service.dart';

class DioClientService {
  static const String _baseUrl = 'https://api.maintboard.com';
  bool _isRefreshing = false;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 10), // 10 seconds to connect
      receiveTimeout: const Duration(seconds: 30), // 30 seconds to receive data
      sendTimeout: const Duration(seconds: 15), // 15 seconds to send data
    ),
  );

  DioClientService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Check for internet connectivity
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          SnackBar(content: Text('No Internet Connection'));

          // Show a Snackbar or handle UI for no internet
          throw DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
            error: 'No Internet Connection',
          );
        }

        // Attach the Authorization header
        final token = await SharedPreferenceService.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401 && !_isRefreshing) {
          _isRefreshing = true;
          try {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              final newIdToken = await user.getIdToken(true);
              await SharedPreferenceService.saveAccessToken(newIdToken!);

              e.requestOptions.headers['Authorization'] = 'Bearer $newIdToken';
              final retryResponse = await _dio.request(
                e.requestOptions.path,
                options: Options(
                  method: e.requestOptions.method,
                  headers: e.requestOptions.headers,
                ),
                data: e.requestOptions.data,
                queryParameters: e.requestOptions.queryParameters,
              );

              _isRefreshing = false;
              return handler.resolve(retryResponse);
            }
          } catch (refreshError) {
            _isRefreshing = false;

            // Optional: Log out the user and redirect to login
            await FirebaseAuth.instance.signOut();
            SnackBar(content: Text('Session expired. Please log in again.'));
            throw DioException(
              requestOptions: e.requestOptions,
              type: DioExceptionType.cancel,
              error: 'Session expired. Please log in again.',
            );
          }
        }

        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;
}
