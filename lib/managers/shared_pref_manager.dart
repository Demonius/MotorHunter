import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager {
  static const String STATE_AUTH = "state_auth";
  static const String USER_ID = "user_id";

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> getStateAuthUser() {
    return _prefs.then(getBoolValue(STATE_AUTH));
  }

  Future<bool> setStateAuthUser(bool stateAuth) async {
    return (await _prefs).setBool(STATE_AUTH, stateAuth).then((bool success) => success);
  }

  Future<int> getCurrentUserId() {
    return _prefs.then(getIntValue(USER_ID));
  }

  Future<bool> setUserId(int userId) async {
    return (await _prefs).setInt(USER_ID, userId).then((bool success) => success);
  }

  FutureOr<int> Function(SharedPreferences pref) getIntValue(String key) {
    return (pref) => pref.getInt(key) ?? -1;
  }

  FutureOr<bool> Function(SharedPreferences pref) getBoolValue(String key) {
    return (pref) => pref.getBool(key) ?? false;
  }
}
