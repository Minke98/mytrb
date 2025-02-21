import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/Repository/app_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
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

  // @override
  // void onInit() {
  //   super.onInit();
  //   // checkAuth(); // Cek autentikasi saat controller dimuat
  // }

  Future<void> login({
    StreamController<String>? stream,
  }) async {
    // isCheckingAuth.value = true;

    var deviceId = await getUniqueDeviceId();
    var res = await userRepository.login(
      username: usernameController.text,
      password: passwordController.text,
      device_id: deviceId,
      stream: stream ?? StreamController<String>(),
    );

    if (res["status"] == false) {
      isCheckingAuth.value = false;
      unauthorizedMessage.value = res['message'] ?? "Unknown Error";
      MyDialog.showErrorSnackbarRegist(unauthorizedMessage.value);
      isAuthorized.value = false;
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("userUc", res['user'].uc);
      var userData = await userRepository.getUserData(uc: res['user'].uc);

      await appRepository.getBaselineData(
        userData: userData['data'],
        stream: stream ?? StreamController<String>(),
      );

      user.value = userData;
      isAuthorized.value = true;
      isCheckingAuth.value = false;
    }
  }

  Future<void> logout() async {
    await userRepository.logOut();
    isAuthorized.value = false;
    user.clear();
  }

  // Future<void> checkAuth({
  //   String? deviceId,
  //   bool background = false,
  //   StreamController<String>? stream,
  // }) async {
  //   isCheckingAuth.value = true;
  //   await Future.delayed(const Duration(milliseconds: 300));

  //   var isAuth = await userRepository.checkAuth(
  //     deviceId: deviceId ?? '',
  //     fromBackround: background,
  //   );

  //   if (isAuth['status'] == false) {
  //     unauthorizedMessage.value = isAuth['message'] ?? "";
  //     isAuthorized.value = false;
  //     user.clear();
  //   } else {
  //     final prefs = await SharedPreferences.getInstance();
  //     prefs.setString("userUc", isAuth['user'].uc);
  //     var userData = await userRepository.getUserData(uc: isAuth['user'].uc);
  //     var streamController = stream ?? StreamController<String>();

  //     await appRepository.getBaselineData(
  //       userData: userData['data'],
  //       stream: streamController,
  //     );

  //     user.value = userData;
  //     isAuthorized.value = true;
  //   }
  //   isCheckingAuth.value = false;
  // }
}
