// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageConfig {
  static const String accessToken = 'accessToken';
  static const String userToken = 'userToken';
  static const String userInfo = 'userInfo';
  static const String deviceToken = 'deviceToken';
  static const String deviceInfo = 'deviceInfo';
  static const String deviceId = 'device_id';
  static const String institutionToken = 'institutionToken';
  static const String institutionInfo = 'institutionInfo';
  static const String userMenu = 'userMenu';
  static const String infoDiklat = 'infoDiklat';
  static const String dataPersyaratanList = 'dataPersyaratanList';
  static const String uploadFile = 'uploadFile';
  static const String reschedule = 'reschedule';
  static const String billingDetail = 'billingDetail';
  static const String changeFoto = 'changeFoto';
}

class StorageManager {
  static late SharedPreferences _storage;

  static Future<void> init() async {
    _storage = await SharedPreferences.getInstance();
  }

  static Future<void> saveData(String key, String value) async {
    await _storage.setString(key, value);
  }

  static String? loadData(String key) {
    return _storage.getString(key);
  }

  static Future<void> clearData(String key) async {
    await _storage.remove(key);
  }
}

// class StorageManager {
//   static const FlutterSecureStorage _storage = FlutterSecureStorage();

//   static Future<FlutterSecureStorage> getInstance() async {
//     _storage;
//     return _storage;
//   }
// }