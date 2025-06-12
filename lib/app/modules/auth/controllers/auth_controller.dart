import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/Repository/app_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:mytrb/utils/auth_biometric.dart';
import 'package:mytrb/utils/connection.dart';
import 'package:mytrb/utils/dialog.dart';
import 'package:mytrb/utils/get_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
    checkAuth();
  }

  Future<void> login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      MyDialog.showErrorSnackbarRegist(
          "Username dan password tidak boleh kosong");
      return;
    }
    bool isAuthenticated = await BiometricAuth.authenticateUser(
        'Use biometric authentication to login');
    if (!isAuthenticated) {
      EasyLoading.showError('Autentikasi biometrik gagal');
      return;
    }
    bool isConnected = await ConnectionUtils.checkInternetConnection();
    if (!isConnected) {
      ConnectionUtils().showNoInternetDialog(
        "Apologies, the login process requires an internet connection.",
      );
      return;
    }

    EasyLoading.show(status: 'Please wait...');
    bool isFastConnection = await ConnectionUtils.isConnectionFast();
    if (!isFastConnection) {
      ConnectionUtils().showNoInternetDialog(
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
    );

    if (res["status"] == false) {
      unauthorizedMessage.value = res['message'] ?? "Unknown Error";
      MyDialog.showErrorSnackbarRegist(unauthorizedMessage.value);
      isAuthorized.value = false;
      EasyLoading.dismiss();
      usernameController.clear();
      passwordController.clear();
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("userUc", res['user'].uc);

      // Panggil fetchUserData setelah login sukses
      await fetchUserData(res['user'].uc);

      isAuthorized.value = true;
      EasyLoading.dismiss();
      usernameController.clear();
      passwordController.clear();

      if (Get.currentRoute != Routes.INDEX && isAuthorized.value) {
        Get.offAllNamed(Routes.INDEX);
      }
    }
  }

  Future<void> fetchUserData(String userUc) async {
    EasyLoading.show(status: 'Refreshing data...');

    var userData = await userRepository.getUserData(uc: userUc);
    await appRepository.getBaselineData(
      userData: userData['data'],
    );

    var userDataNew = await userRepository.getUserData(uc: userUc);

    user.value = userDataNew; // Update user
    EasyLoading.dismiss();
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

  Future<bool> checkAuth({bool background = false}) async {
    if (isCheckingAuth.value) return false; // Mencegah duplikasi eksekusi

    isCheckingAuth.value = true;
    EasyLoading.show(status: 'Checking authentication...');

    var deviceId = await getUniqueDeviceId();
    var isAuth = await userRepository.checkAuth(
      deviceId: deviceId,
      fromBackround: background,
    );

    EasyLoading.dismiss();

    if (isAuth['status'] == false) {
      unauthorizedMessage.value = isAuth['message'] ?? "Unauthorized access";
      isAuthorized.value = false;
      user.clear();

      if (Get.currentRoute != Routes.LOGIN) {
        Get.toNamed(Routes.LOGIN);
      }

      isCheckingAuth.value = false;

      Future.delayed(const Duration(milliseconds: 500), () {
        if (Get.isDialogOpen == false &&
            unauthorizedMessage.value != "Unauthorized access") {
          showAuthDialog(unauthorizedMessage.value);
        }
      });

      return false;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("userUc", isAuth['user'].uc);
    await fetchUserData(isAuth['user'].uc);
    bool isAuthenticated = await BiometricAuth.tryBiometricAuthentication();
    if (!isAuthenticated) {
      return false;
    }
    isAuthorized.value = true;

    if (Get.currentRoute != Routes.INDEX && isAuthorized.value) {
      Get.toNamed(Routes.INDEX);
    }

    isCheckingAuth.value = false;
    return true;
  }

  Future<void> openWhatsAppGroup() async {
    bool isConnected = await ConnectionUtils.checkInternetConnection();
    if (!isConnected) {
      EasyLoading.dismiss();
      ConnectionUtils().showNoInternetDialog(
        "Apologies, the login process requires an internet connection.",
      );
      return;
    }

    bool isFastConnection = await ConnectionUtils.isConnectionFast();
    if (!isFastConnection) {
      EasyLoading.dismiss();
      ConnectionUtils().showNoInternetDialog(
        "Apologies, the login process requires a stable internet connection.",
        isSlowConnection: true,
      );
      return;
    }
    final userchat = user['data'];
    final seafarerCode = userchat?['seafarer_code'];
    final ucTrbSchedule = userchat?['uc_trb_schedule'];

    if (seafarerCode == null || ucTrbSchedule == null) {
      Get.snackbar("Error", "Data peserta belum lengkap.");
      return;
    }

    EasyLoading.show(status: 'Membuka grup...');

    await BaseClient.safeApiCall(
      Environment.chat,
      RequestType.get,
      queryParameters: {
        'seafarer_code': seafarerCode,
        'uc_trb_schedule': ucTrbSchedule,
      },
      onSuccess: (response) async {
        EasyLoading.dismiss();
        final groupUrl = response.data['url_wa'];
        final uri = Uri.parse(groupUrl);

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          Get.snackbar("Error", "Tidak dapat membuka WhatsApp");
        }
      },
      onError: (error) {
        EasyLoading.dismiss();
        Get.snackbar("Error", error.message);
      },
    );
  }

  void showAuthDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          "Informasi",
          style: TextStyle(fontSize: 16),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "OK",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
