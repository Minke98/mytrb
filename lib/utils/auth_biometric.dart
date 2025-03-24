import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuth {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> authenticateUser(String reason) async {
    bool isAuthenticated = false;

    try {
      isAuthenticated = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print("Biometric error: $e");
    }

    return isAuthenticated;
  }

  static Future<bool> tryBiometricAuthentication() async {
    bool isAuthenticated =
        await authenticateUser('Use biometric authentication to login');
    if (!isAuthenticated) {
      bool retry = await Get.defaultDialog(
        title: "Authentication Failed",
        middleText:
            "Gagal autentikasi biometrik. Apakah Anda ingin mencoba lagi?",
        textConfirm: "Coba Lagi",
        textCancel: "Batal",
        confirmTextColor: Colors.white,
        onConfirm: () => Get.back(result: true), // Kembali dengan hasil true
        onCancel: () => Get.back(result: false), // Kembali dengan hasil false
      );
      if (retry) {
        return await tryBiometricAuthentication(); // Coba lagi autentikasi
      } else {
        EasyLoading.showError('Autentikasi biometrik dibatalkan');
        return false;
      }
    }
    return true;
  }
}
