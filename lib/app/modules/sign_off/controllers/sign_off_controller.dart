import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytrb/app/Repository/sign_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/app/components/constant.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/utils/auth_biometric.dart';
import 'package:mytrb/utils/connection.dart';
import 'package:mytrb/utils/dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mytrb/utils/location.dart';
import 'package:path/path.dart' as Path;

class SignoffController extends GetxController {
  final SignRepository signRepository;
  SignoffController({required this.signRepository});
  final IndexController indexController = Get.put(
      IndexController(signRepository: Get.find(), syncRepository: Get.find()));
  var sch = 0.obs;
  var scw = 0.obs;
  var isLoading = false.obs;
  var signUc = ''.obs;
  var signData = {}.obs;
  final Rx<XFile?> signOffPelabuhanFoto = Rx<XFile?>(null);
  final Rx<XFile?> signOffImoFoto = Rx<XFile?>(null);
  final Rx<XFile?> crewListFoto = Rx<XFile?>(null);
  var signOffPelabuhanFotoError = ''.obs;
  var signOffImoFotoError = ''.obs;
  var crewListFotoError = ''.obs;
  var signOnFoto = Rxn<ImageProvider>();

  @override
  void onInit() {
    super.onInit();
    prepareSignOff();
  }

  Future<void> prepareSignOff() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? techUser = prefs.getString("userUc");
    if (techUser == null) {
      isLoading.value = false;
      return;
    }

    var user = await UserRepository.getLocalUser(uc: techUser);
    if (user['status'] == true) {
      user = user['data'];
    }

    Map getSignStatus =
        await signRepository.getStatus(seafarerCode: user["seafarer_code"]);
    if (getSignStatus['status'] == false) {
      getSignStatus['signData'] = {};
    }

    signUc.value = getSignStatus['sign_uc'] ?? '';
    signData.value = getSignStatus['signData'] ?? {};

    isLoading.value = false;
  }

  Future<void> signOff() async {
    bool isAuthenticated = await BiometricAuth.authenticateUser(
        'Use biometric authentication to login');
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
    Map getPos = await Location.getLocation();
    if (getPos['status'] == false) {
      if (Get.context != null) {
        MyDialog.showError(Get.context!, getPos['message']);
      }
      return;
    }

    Position pos = getPos['position'];
    EasyLoading.show(status: 'Processing...');

    try {
      await signRepository.doSignOff(
        signUc: signUc.value,
        pos: pos,
        signOffPelabuhanFoto: signOffPelabuhanFoto.value != null
            ? File(signOffPelabuhanFoto.value!.path)
            : null,
        crewListFoto:
            crewListFoto.value != null ? File(crewListFoto.value!.path) : null,
        signOffImoFoto: signOffImoFoto.value != null
            ? File(signOffImoFoto.value!.path)
            : null,
      );

      // Jika semua foto tidak null, navigasi ke halaman utama
      if (signOffPelabuhanFoto.value != null &&
          crewListFoto.value != null &&
          signOffImoFoto.value != null) {
        Get.offAllNamed(Routes.INDEX);
      }
    } catch (e) {
      MyDialog.showError(Get.context!, "Terjadi kesalahan: \$e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<ImageProvider<Object>> loadImage(
      String imagePath, String? imageUrl) async {
    bool imageExist = await File(imagePath).exists();
    if (!imageExist && imageUrl != null) {
      try {
        log("Loading Image $imagePath $imageUrl");
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;
        String savePath = Path.join(appDocPath, SIGN_PROFILE_FOLDER);
        Directory(savePath).createSync(recursive: true);

        await BaseClient.download(
          url: imageUrl,
          savePath: imagePath,
          onSuccess: () => log("Download sukses"),
          onError: (e) {
            log("Download gagal: /$e");
          },
        );

        if (await File(imagePath).exists()) {
          return FileImage(File(imagePath));
        } else {
          return const AssetImage('assets/images/download-failed-1.png');
        }
      } catch (e) {
        log("Loading Image Error: \$e");
        return const AssetImage('assets/images/download-failed-1.png');
      }
    } else {
      log("Image Exists");
      return FileImage(File(imagePath));
    }
  }
}
