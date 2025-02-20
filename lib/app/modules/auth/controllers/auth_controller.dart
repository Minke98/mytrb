import 'dart:async';

import 'package:get/get.dart';
import 'package:mytrb/app/Repository/app_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final UserRepository userRepository;
  final AppRepository appRepository;

  var isCheckingAuth = false.obs;
  var isAuthorized = false.obs;
  var user = {}.obs;
  var unauthorizedMessage = "".obs;

  AuthController({required this.userRepository, required this.appRepository});

  @override
  void onInit() {
    super.onInit();
    checkAuth(); // Cek autentikasi saat controller dimuat
  }

  Future<void> login({
    required String username,
    required String password,
    required String deviceId,
    StreamController<String>? stream,
  }) async {
    isCheckingAuth.value = true;
    var res = await userRepository.login(
      username: username,
      password: password,
      device_id: deviceId,
      stream: stream ?? StreamController<String>(),
    );

    if (res["status"] == false) {
      isCheckingAuth.value = false;
      unauthorizedMessage.value = res['message'] ?? "Unknown Error";
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

  Future<void> checkAuth({
    String? deviceId,
    bool background = false,
    StreamController<String>? stream,
  }) async {
    isCheckingAuth.value = true;
    await Future.delayed(const Duration(milliseconds: 300));

    var isAuth = await userRepository.checkAuth(
      deviceId: deviceId ?? '',
      fromBackround: background,
    );

    if (isAuth['status'] == false) {
      unauthorizedMessage.value = isAuth['message'] ?? "";
      isAuthorized.value = false;
      user.clear();
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("userUc", isAuth['user'].uc);
      var userData = await userRepository.getUserData(uc: isAuth['user'].uc);
      var streamController = stream ?? StreamController<String>();

      await appRepository.getBaselineData(
        userData: userData['data'],
        stream: streamController,
      );

      user.value = userData;
      isAuthorized.value = true;
    }
    isCheckingAuth.value = false;
  }
}
