import 'package:mytrb/app/routes/app_pages.dart';
import 'package:mytrb/config/storage/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUtil {
  static Future<void> signout() async {
    final storage = await SharedPreferences.getInstance();
    try {
      await storage.remove(StorageConfig.userInfo);
      if (Get.currentRoute != "/" && Get.currentRoute == Routes.INDEX) {
        Get.deleteAll(force: false);
        Get.offAndToNamed("/");
      } else if (Get.currentRoute != "/" && Get.currentRoute != Routes.INDEX) {
        Get.offAndToNamed("/");
      }
      Get.snackbar(
        'Success',
        'You have been successfully signed out',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        borderRadius: 20,
        margin: const EdgeInsets.all(15),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutBack,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error while signing out: $e');
      }
      Get.snackbar(
        'Failed',
        'Failed to sign out. Please try again later.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent[400],
        borderRadius: 20,
        margin: const EdgeInsets.all(15),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutBack,
      );
    }
  }
}
