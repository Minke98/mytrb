import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mytrb/app/Repository/app_repository.dart';
import 'package:mytrb/app/Repository/repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:mytrb/app/services/api_call_status.dart';
import 'package:mytrb/utils/connection.dart';
import 'package:get/get.dart';
import 'package:mytrb/utils/dialog.dart';
import 'package:mytrb/utils/get_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;
  final UserRepository userRepository;
  final AppRepository appRepository;

  var isCheckingAuth = false.obs;
  var isAuthorized = false.obs;
  var user = {}.obs;
  var unauthorizedMessage = "".obs;
  Dialog? loadingDialog;

  SplashController({required this.userRepository, required this.appRepository});

  @override
  void onInit() async {
    super.onInit();
    await Future.delayed(const Duration(seconds: 3));
    await checkInternetAndUserStatus();
  }

  Future<void> checkInternetAndUserStatus() async {
    bool isConnected = await ConnectionUtils.checkInternetConnection();
    if (!isConnected) {
      ConnectionUtils.showNoInternetDialog(
          'Please check your internet connection and try again.');
    } else {
      Get.toNamed(Routes.LOGIN);
      // await checkUserLogin();
    }
  }

  Future<void> checkUserLogin() async {
    isCheckingAuth.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    String deviceId = await getUniqueDeviceId();
    var isAuth = await userRepository.checkAuth(
        deviceId: deviceId, fromBackround: false);

    if (isAuth['status'] == false) {
      unauthorizedMessage.value = isAuth['message'] ?? "";
      isAuthorized.value = false;
      user.clear();
      _handleUnauthorized();
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("userUc", isAuth['user'].uc);
      var userData = await userRepository.getUserData(uc: isAuth['user'].uc);

      await appRepository.getBaselineData(
        userData: userData['data'],
        stream: StreamController<String>(),
      );

      user.value = userData;
      isAuthorized.value = true;

      _handleAuthorized();
    }
    isCheckingAuth.value = false;
  }

  Future<void> _handleAuthorized() async {
    bool isNeedSync = await Repository.isNeedSync();
    var connectivityResult = await Connectivity().checkConnectivity();
    bool isInternetAvailable =
        (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi);

    if (isNeedSync && isInternetAvailable) {
      Get.offAllNamed("/sync");
    } else {
      Timer.periodic(const Duration(milliseconds: 300), (timer) async {
        if (loadingDialog != null && MyDialog.isAnyOpen(Get.context!) == true) {
          Get.back();
          loadingDialog = null;
        }
        if (loadingDialog == null) {
          timer.cancel();
          if (isInternetAvailable) {
            if (isNeedSync) {
              Get.offAllNamed("/sync");
            } else {
              Get.offAllNamed("/home");
            }
          }
        }
      });
    }
  }

  Future<void> _handleUnauthorized() async {
    if (loadingDialog != null) {
      Timer.periodic(const Duration(milliseconds: 300), (timer) async {
        if (loadingDialog != null && MyDialog.isAnyOpen(Get.context!) == true) {
          Get.back();
          loadingDialog = null;
        }
        if (loadingDialog == null) {
          timer.cancel();
          await userRepository.logOut();
          if (unauthorizedMessage.value.isNotEmpty) {
            await _showError(Get.context, unauthorizedMessage.value);
          }
          Get.offAllNamed('/');
        }
      });
    }
  }

  Future<void> _showError(BuildContext? context, String message) async {
    if (context != null) {
      await MyDialog.showError(context, message);
    }
  }

  // Future<void> statusApps(Map<String, dynamic> payload) async {
  //   bool isConnected = await ConnectionUtils.checkInternetConnection();
  //   if (!isConnected) {
  //     ConnectionUtils.showNoInternetDialog(
  //         'Please check your internet connection and try again.');
  //   } else {
  //     EasyLoading.show(status: 'Please wait...');
  //     await BaseClient.safeApiCall(
  //       Environment.updateBiodata,
  //       RequestType.post,
  //       data: payload,
  //       isJson: false,
  //       onLoading: () {
  //         apiCallStatus = ApiCallStatus.loading;
  //         update();
  //       },
  //       onSuccess: (response) async {
  //         EasyLoading.dismiss();
  //         var res = response.data;
  //         var data = res['data'];
  //         if (data != null && data['status'] == '1') {
  //           Get.toNamed(Routes.MAINTENANCE);
  //         } else {
  //           checkUserLoggedIn();
  //         }
  //       },
  //       onError: (error) {
  //         EasyLoading.dismiss();
  //         BaseClient.handleApiError(error);
  //         apiCallStatus = ApiCallStatus.error;
  //         update();
  //       },
  //     );
  //   }
  // }
}
