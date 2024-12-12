import 'dart:developer';

import 'package:chat_app/data/exceptions/app_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static SharedPreferences? _instance;
  final String _accessToken = "accessToken"; // New field
  final String _refreshToken = "refreshToken"; // New field
  final String _loggedInString = "loggedIn";
  final String _userId = "userId";
  final String _notificationSubscriptionId = "notificationSubscriptionId";
  Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  Future<void> setUserId(String token) async {
    await _instance!.setString(_userId, token);
  }

  Future<void> setNotificationSubscription(String value) async {
    await _instance!.setString(_notificationSubscriptionId, value);
  }

  Future<void> setLoggedIn([bool state = true]) async {
    print(state);
    await _instance!.setBool(_loggedInString, state);
    getLoggedIn();
  }

  Future<void> setToken(String accessToken, String refreshToken) async {
    await _instance!.setString(_accessToken, accessToken);
    await _instance!.setString(_refreshToken, refreshToken);
    getAccessToken();
  }

  String getUserId() {
    String? userId = _instance!.getString(_userId);
    if (userId != null) {
      return userId;
    } else {
      throw CacheExceptions(000, message: "Access token not found");
    }
  }

  String getAccessToken() {
    String? token = _instance!.getString(_accessToken);
    if (token != null) {
      return token;
    } else {
      throw CacheExceptions(000, message: "Access token not found");
    }
  }

  String getNotificationSubscriptionId() {
    String? id = _instance!.getString(_notificationSubscriptionId) ?? "";
    return id;
  }

  bool? getLoggedIn() {
    bool login = _instance!.getBool(_loggedInString) ?? false;
    log(login.toString());
    return login;
  }

  String getRefreshToken() {
    String? token = _instance!.getString(_refreshToken);
    if (token != null) {
      return token;
    } else {
      throw CacheExceptions(000, message: "Refresh token not found");
    }
  }
}
