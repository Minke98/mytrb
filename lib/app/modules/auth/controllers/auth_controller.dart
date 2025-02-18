import 'dart:convert';
import 'package:mytrb/app/data/models/login.dart';
import 'package:mytrb/utils/connection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
// import 'package:mytrb/app/data/models/user.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:mytrb/config/storage/storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/environment/environment.dart';
import '../../../services/api_call_status.dart';
import '../../../services/base_client.dart';

class AuthController extends GetxController {
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;
  final TextEditingController nikController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController namaLengkapController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noTeleponController = TextEditingController();
  final TextEditingController seafarersCodeController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  late FlutterSecureStorage storage;
  var isAuthenticated = false.obs;
  var imei = ''.obs;
  bool isUsernameInvalid = false;
  bool isPasswordInvalid = false;
  final kodePelautController = TextEditingController();
  var gender = ''.obs;
  var typeReg = "".obs;

  @override
  void onInit() {
    super.onInit();
    getDeviceId();
  }

  void setUnauthenticated() {
    isAuthenticated.value = false;
    // Misalnya, arahkan pengguna ke halaman login
    Get.offAllNamed(Routes.LOGIN);
  }

  bool isValidEmail(String value) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(value);
  }

  Future<void> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (GetPlatform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      imei.value = androidInfo.model + androidInfo.id;
      if (kDebugMode) {
        print('IMEI/Android ID: $imei');
      }
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      imei.value = iosInfo.name + iosInfo.identifierForVendor!;
      if (kDebugMode) {
        print('IMEI/iOS ID: $imei');
      }
    }
  }

  Future<void> regist() async {
    // Check internet connection
    bool isConnected = await ConnectionUtils.checkInternetConnection();
    if (!isConnected) {
      ConnectionUtils.showNoInternetDialog(
        "Apologies, the registration process requires an internet connection.",
      );
      return;
    }

    EasyLoading.show(status: 'Please wait...');
    bool isFastConnection = await ConnectionUtils.isConnectionFast();
    if (!isFastConnection) {
      ConnectionUtils.showNoInternetDialog(
        "Apologies, the registration process requires a stable internet connection.",
        isSlowConnection: true,
      );
      return;
    }

    final data = {
      'nik': nikController.text.trim(),
      'nama_lengkap': namaLengkapController.text.trim(),
      'tempat_lahir': tempatLahirController.text.trim(),
      'tanggal_lahir': tanggalLahirController.text.trim(),
      'jk': gender.value,
      'no_telepon': noTeleponController.text.trim(),
      'email': emailController.text.trim(),
      'alamat_rumah': alamatController.text.trim(),
      'type_reg': typeReg.value,
    };
    if (kodePelautController.text.trim().isNotEmpty) {
      data['seafarers_code'] = kodePelautController.text.trim();
    }

    await BaseClient.safeApiCall(
      Environment.regist,
      RequestType.post,
      data: data,
      onSuccess: (response) async {
        EasyLoading.dismiss();
        showSuccessSnackbar();
        // var res = response.data;
        // var user = res['data'];
        // User regUser = User.fromJson(user);
        // String? playerId;
        // await OneSignal.shared.getDeviceState().then((deviceState) {
        //   playerId = deviceState?.userId;
        // });

        // if (playerId != null) {
        //   await sendOneSignalNotification(playerId!, regUser.namaLengkap!);
        // }
        clearController();
        Get.offAllNamed(Routes.LOGIN);
        apiCallStatus = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        EasyLoading.dismiss(); // Close loading on error
        String errorMessage = error.message;
        showErrorSnackbarRegist(errorMessage);
        clearController();
        if (kDebugMode) {
          print("Error: $errorMessage");
        }
        showErrorSnackbar();
        update();
      },
    );
  }

  Future<void> sendOneSignalNotification(
      String playerId, String namaLengkap) async {
    final notificationData = {
      "app_id": Environment.oneSignalAppId,
      "include_player_ids": [playerId],
      "headings": {"en": "Selamat datang, $namaLengkap"},
      "contents": {"en": "Registrasi berhasil!"},
    };

    await BaseClient.safeApiCall(
      Environment.oneSignalApiUrl,
      RequestType.post,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ${Environment.oneSignalRestApiKey}',
      },
      data: notificationData,
      isJson: true,
      onSuccess: (response) {
        if (kDebugMode) {
          print('Notifikasi berhasil dikirim');
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('Gagal mengirim notifikasi: ${error.message}');
        }
      },
    );
  }

  login() async {
    // Check internet connection
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
    var playerId = OneSignal.User.pushSubscription.id;
    await BaseClient.safeApiCall(
      Environment.login,
      RequestType.post,
      data: {
        'nik': nikController.text.trim(),
        'password': pinController.text.trim(),
        'player_id': playerId,
      },
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        EasyLoading.dismiss();
        var res = response.data;
        var userLogin = res['data'];
        UserLogin regUser = UserLogin.fromJson(userLogin);
        final storage = await SharedPreferences.getInstance();
        await storage.setString(
            StorageConfig.userInfo, jsonEncode(regUser.toJson()));
        clearController();
        Get.toNamed(Routes.INDEX);
        apiCallStatus = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        EasyLoading.dismiss();
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  clearController() {
    nikController.clear();
    emailController.clear();
    namaLengkapController.clear();
    tempatLahirController.clear();
    tanggalLahirController.clear();
    alamatController.clear();
    noTeleponController.clear();
    seafarersCodeController.clear();
    pinController.clear();
  }

  void showSuccessSnackbar() {
    Get.snackbar(
      "Congratulations",
      "Registration Successful",
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

  void showErrorSnackbarRegist(value) {
    Get.snackbar(
      "Apologies",
      "$value",
      icon: const Icon(
        Icons.close,
        color: Colors.white,
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.redAccent[400],
      borderRadius: 20,
      margin: const EdgeInsets.all(15),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  void showErrorSnackbar() {
    Get.snackbar(
      "Apologies",
      "An error occurred. Please try again.",
      icon: const Icon(
        Icons.close,
        color: Colors.white,
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.redAccent[400],
      borderRadius: 20,
      margin: const EdgeInsets.all(15),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}
