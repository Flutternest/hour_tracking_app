import 'dart:developer';

import 'package:flux_mvp/core/services/pref_storage/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefKeys {
  static const String isLoggedIn = 'isLoggedIn';
  static const String loginType = 'loginType';
  static const String userDetails = 'userDetails';
  static const String timerCount = 'timerCount';
  static const String timerLoggingDateTime = 'timerLoggingDateTime';

  static const String isTimerOnGoing = "isOnGoingTrip";
}

class SharedPrefService implements StorageService {
  final SharedPreferences prefs;

  SharedPrefService(this.prefs);

  @override
  dynamic get(String key) {
    log("SharedPrefService.get: $key");
    return prefs.get(key);
  }

  @override
  bool has(String key) {
    log("SharedPrefService.has: $key");
    return prefs.containsKey(key);
  }

  @override
  Future<void> set<T>(String key, T data) {
    log("SharedPrefService.set: $key");
    switch (data.runtimeType) {
      case String:
        return prefs.setString(key, data as String);
      case int:
        return prefs.setInt(key, data as int);
      case double:
        return prefs.setDouble(key, data as double);
      case bool:
        return prefs.setBool(key, data as bool);
      case List:
        return prefs.setStringList(key, data as List<String>);
      default:
        return Future.error('Unsupported type');
    }
  }

  @override
  Future<void> clear() {
    log("SharedPrefService.clear");
    return prefs.clear();
  }

  @override
  Future<void> remove(String key) {
    log("SharedPrefService.remove: $key");
    return prefs.remove(key);
  }
}
