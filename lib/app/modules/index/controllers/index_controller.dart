import 'dart:convert';
import 'package:mytrb/app/data/models/login.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:mytrb/config/storage/storage.dart';
import 'package:mytrb/utils/auth_util.dart';
import 'package:mytrb/utils/connection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/services/api_call_status.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexController extends GetxController {
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;
  Rx<UserLogin?> currentUser = Rx<UserLogin?>(null);
  var isLoggedIn = false.obs;
  String? notificationType;
  Map<String, String?> notificationData = {};

  // @override
  // void onInit() {
  //   super.onInit();
  //   loadUserInfo();
  //   getPlayerId();
  // }

  Future<void> getPlayerId() async {
    try {
      var deviceState = OneSignal.User.pushSubscription.id;
      if (kDebugMode) {
        print('PLAYER ID ::: $deviceState');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting playerId: $e');
      }
    }
  }

  Future<void> loadUserInfo() async {
    final storage = await SharedPreferences.getInstance();
    String? userInfo = storage.getString(StorageConfig.userInfo);

    if (userInfo != null && userInfo.isNotEmpty) {
      var userMap = jsonDecode(userInfo);
      currentUser.value = UserLogin.fromJson(userMap);
      isLoggedIn.value = currentUser.value != null;
      if (kDebugMode) {
        print('Current user: ${currentUser.value?.toJson()}');
      } // Example usage
    }
  }

  Future<void> statusApps(Map<String, dynamic> payload) async {
    bool isConnected = await ConnectionUtils.checkInternetConnection();
    if (!isConnected) {
      ConnectionUtils.showNoInternetDialog(
          'Please check your internet connection and try again.');
    } else {
      EasyLoading.show(status: 'Please wait...');
      await BaseClient.safeApiCall(
        Environment.updateBiodata,
        RequestType.post,
        data: payload,
        isJson: false,
        onLoading: () {
          apiCallStatus = ApiCallStatus.loading;
          update();
        },
        onSuccess: (response) async {
          EasyLoading.dismiss();
          var res = response.data;
          var data = res['data'];
          if (data != null && data['status'] == '1') {
            Get.snackbar(
              'Mohon Maaf',
              'Sistem sedang dalam perbaikan',
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
          }
        },
        onError: (error) {
          EasyLoading.dismiss();
          BaseClient.handleApiError(error);
          apiCallStatus = ApiCallStatus.error;
          update();
        },
      );
    }
  }

  void clearNotificationData() {
    notificationType = null;
    notificationData = {};
  }

  void signout() {
    AuthUtil.signout();
  }
}
