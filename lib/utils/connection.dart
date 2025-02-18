import 'package:mytrb/app/routes/app_pages.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

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

  static void showNoInternetDialog(String message,
      {bool isSlowConnection = false}) {
    showDialog(
      context: Get.context!,
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
                isSlowConnection
                    ? 'assets/animations/slow_connection.json'
                    : 'assets/animations/failed.json',
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
                Get.toNamed(Routes.LOGIN);
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
