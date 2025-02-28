import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:mytrb/app/services/api_call_status.dart';
import 'package:mytrb/utils/connection.dart';
import 'package:get/get.dart';
// import 'package:mytrb/utils/get_device_id.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;

  var isCheckingAuth = false.obs;
  var isAuthorized = false.obs;
  var user = {}.obs;
  var unauthorizedMessage = "".obs;
  Dialog? loadingDialog;

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
