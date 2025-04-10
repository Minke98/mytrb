import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mytrb/app/Repository/app_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:mytrb/app/services/api_call_status.dart';
// import 'package:mytrb/utils/connection.dart';
import 'package:get/get.dart';
import 'package:mytrb/utils/auth_biometric.dart';
import 'package:mytrb/utils/get_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mytrb/utils/get_device_id.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  final UserRepository userRepository;
  final AppRepository appRepository;

  var isCheckingAuth = false.obs;
  var isAuthorized = false.obs;
  var user = {}.obs;
  var unauthorizedMessage = "".obs;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  SplashController({required this.userRepository, required this.appRepository});
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;
  Dialog? loadingDialog;

  @override
  void onInit() async {
    super.onInit();
    await Future.delayed(const Duration(seconds: 3));
    await checkInternetAndUserStatus();
  }

  Future<void> checkInternetAndUserStatus() async {
    // bool isConnected = await ConnectionUtils.checkInternetConnection();
    // if (!isConnected) {
    //   ConnectionUtils.showNoInternetDialog(
    //       'Please check your internet connection and try again.');
    // } else {
    Get.toNamed(Routes.LOGIN);
    // await checkAuth();
    // }
  }

  Future<void> checkAuth({bool background = false}) async {
    if (isCheckingAuth.value) return; // Cegah duplikasi eksekusi

    isCheckingAuth.value = true;
    EasyLoading.show(status: 'Checking authentication...');

    var deviceId = await getUniqueDeviceId();
    var isAuth = await userRepository.checkAuth(
      deviceId: deviceId,
      fromBackround: background,
    );

    EasyLoading.dismiss();

    if (isAuth['status'] == false) {
      unauthorizedMessage.value = isAuth['message'] ?? "";
      isAuthorized.value = false;
      user.clear();

      if (Get.currentRoute != Routes.LOGIN) {
        Get.toNamed(Routes.LOGIN);
      }
      isCheckingAuth.value = false;
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setString("userUc", isAuth['user'].uc);
    var userData = await userRepository.getUserData(uc: isAuth['user'].uc);

    await appRepository.getBaselineData(
      userData: userData['data'],
    );

    // **Cek apakah sudah pernah authenticate dalam session ini**
    bool hasAuthenticated = prefs.getBool("hasAuthenticated") ?? false;

    if (!hasAuthenticated) {
      bool isAuthenticated = await BiometricAuth.authenticateUser(
          'Gunakan autentikasi biometrik untuk melanjutkan');

      if (!isAuthenticated) {
        EasyLoading.showError('Autentikasi biometrik gagal');
        isCheckingAuth.value = false; // Reset state
        return;
      }

      // **Simpan bahwa biometric sudah sukses dalam sesi ini**
      prefs.setBool("hasAuthenticated", true);
    }

    user.value = userData;
    isAuthorized.value = true;

    if (Get.currentRoute != Routes.INDEX && isAuthorized.value) {
      Get.toNamed(Routes.INDEX);
    }

    isCheckingAuth.value = false;

    // **Cegah pemanggilan ulang jika dialog sudah ditampilkan sebelumnya**
    if (isAuth['message'] != null && isAuth['message'].toString().isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!Get.isDialogOpen!) {
          showAuthDialog(isAuth['message'].toString());
        }
      });
    }
  }

  void showAuthDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          "Informasi",
          style: TextStyle(fontSize: 14),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
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
