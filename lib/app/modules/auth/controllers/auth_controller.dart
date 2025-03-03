import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mytrb/app/Repository/app_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:mytrb/utils/connection.dart';
import 'package:mytrb/utils/dialog.dart';
import 'package:mytrb/utils/get_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final UserRepository userRepository;
  final AppRepository appRepository;

  var isCheckingAuth = false.obs;
  var isAuthorized = false.obs;
  var user = {}.obs;
  var unauthorizedMessage = "".obs;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  AuthController({required this.userRepository, required this.appRepository});

  @override
  Future<void> onInit() async {
    super.onInit();
    await checkAuth();
  }

  Future<bool> authenticateUser() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool isAuthenticated = false;

    try {
      isAuthenticated = await auth.authenticate(
        localizedReason: 'Gunakan biometrik untuk login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print("Error biometrik: $e");
    }

    return isAuthenticated;
  }

  Future<void> login() async {
    bool isAuthenticated = await authenticateUser();
    if (!isAuthenticated) {
      EasyLoading.showError('Autentikasi biometrik gagal');
      return;
    }
    bool isConnected = await ConnectionUtils.checkInternetConnection();
    if (!isConnected) {
      ConnectionUtils.showNoInternetDialog(
        "Apologies, the login process requires an internet connection.",
      );
      return;
    }

    EasyLoading.show(status: 'Please wait...');
    bool isFastConnection = await ConnectionUtils.isConnectionFast();
    if (!isFastConnection) {
      ConnectionUtils.showNoInternetDialog(
        "Apologies, the login process requires a stable internet connection.",
        isSlowConnection: true,
      );
      return;
    }
    var deviceId = await getUniqueDeviceId();

    var res = await userRepository.login(
      username: usernameController.text,
      password: passwordController.text,
      device_id: deviceId,
      // stream: _streamController!,
    );

    if (res["status"] == false) {
      unauthorizedMessage.value = res['message'] ?? "Unknown Error";
      MyDialog.showErrorSnackbarRegist(unauthorizedMessage.value);
      isAuthorized.value = false;
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("userUc", res['user'].uc);
      var userData = await userRepository.getUserData(uc: res['user'].uc);

      await appRepository.getBaselineData(
        userData: userData['data'],
        // stream: _streamController!,
      );

      user.value = userData;
      isAuthorized.value = true;
      EasyLoading.dismiss();

      if (Get.currentRoute != Routes.INDEX && isAuthorized.value) {
        Get.offAllNamed(Routes.INDEX);
      }
    }
  }

  Future<void> logout() async {
    EasyLoading.show(status: 'Logging out...');
    await userRepository.logOut();
    isAuthorized.value = false;
    user.clear();
    EasyLoading.dismiss();

    if (Get.currentRoute != Routes.LOGIN) {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<void> checkAuth({bool background = false}) async {
    // bool isAuthenticated = await authenticateUser();
    // if (!isAuthenticated) {
    //   EasyLoading.showError('Autentikasi biometrik gagal');
    //   return;
    // }
    // bool isConnected = await ConnectionUtils.checkInternetConnection();
    // if (!isConnected) {
    //   ConnectionUtils.showNoInternetDialog(
    //     "Apologies, the login process requires an internet connection.",
    //   );
    //   return;
    // }

    // EasyLoading.show(status: 'Please wait...');
    // bool isFastConnection = await ConnectionUtils.isConnectionFast();
    // if (!isFastConnection) {
    //   ConnectionUtils.showNoInternetDialog(
    //     "Apologies, the login process requires a stable internet connection.",
    //     isSlowConnection: true,
    //   );
    //   return;
    // }
    // EasyLoading.dismiss();
    if (isCheckingAuth.value) return;

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
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("userUc", isAuth['user'].uc);
      var userData = await userRepository.getUserData(uc: isAuth['user'].uc);

      await appRepository.getBaselineData(
        userData: userData['data'],
      );

      user.value = userData;
      isAuthorized.value = true;

      if (Get.currentRoute != Routes.INDEX && isAuthorized.value) {
        Get.toNamed(Routes.INDEX);
      }
    }

    isCheckingAuth.value = false;

    // **Tampilkan dialog hanya jika ada pesan**
    if (isAuth['message'] != null && isAuth['message'].toString().isNotEmpty) {
      showAuthDialog(isAuth['message'].toString());
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
}
