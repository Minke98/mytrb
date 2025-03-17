import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/routes/app_pages.dart';

class ConnectionUtils {
  static const Duration _timeoutDuration = Duration(seconds: 5);

  static Future<bool> checkInternetConnection() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> isConnectionFast() async {
    try {
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none) {
        return false;
      }
      // Simulate a network call to check connection speed
      var isConnected = await Future.any([
        Future.delayed(
            _timeoutDuration, () => false), // Simulate slow connection
        Future.delayed(const Duration(milliseconds: 500),
            () => true), // Simulate fast connection
      ]);
      return isConnected;
    } catch (e) {
      return false;
    }
  }

  void showNoInternetDialog(String message,
      {bool isSlowConnection = false, bool closeToHome = false}) {
    print("showNoInternetDialog called with:");
    print("Message: $message");
    print("isSlowConnection: $isSlowConnection");
    print("closeToHome: $closeToHome");

    showDialog(
      context: Get.overlayContext ?? Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Center(
            child: Text(
              isSlowConnection
                  ? "Unstable internet connection."
                  : "No Internet Connection",
              style: const TextStyle(fontSize: 18),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/failed.json',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (closeToHome) {
                  Get.offAllNamed(Routes.INDEX);
                } else {
                  print("Closing dialog...");
                  Get.back();
                }
              },
              child: const Text(
                "Close",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }
}
