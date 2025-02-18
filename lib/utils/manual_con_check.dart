// import 'dart:developer';
import 'dart:io';

// import 'package:flutter/services.dart';

class ConnectionTest {
  static Future check() async {
    try {
      final result =
          await InternetAddress.lookup("google.com");
      // log("RES $result");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
