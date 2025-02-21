import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDialog {
  static bool isAnyOpen(BuildContext ctx) {
    return ModalRoute.of(ctx)?.isCurrent != true;
  }

  static Future<void> showError(BuildContext context, String message) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // 🔥 Ubah jadi static agar bisa dipanggil langsung
  static void showErrorSnackbarRegist(value) {
    Get.snackbar(
      "Apologies",
      "$value",
      icon: const Icon(
        Icons.close,
        color: Colors.white,
      ),
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
