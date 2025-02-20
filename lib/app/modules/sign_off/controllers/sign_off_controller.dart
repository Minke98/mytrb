import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/Repository/sign_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignoffController extends GetxController {
  final SignRepository signRepository;
  SignoffController({required this.signRepository});

  var isLoading = false.obs;
  var signUc = ''.obs;
  var signData = {}.obs;

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

  Future<void> signOff({
    required String ucSign,
    required Position position,
    required File signOffPelabuhanFoto,
    required File crewListFoto,
    required File signOffImoFoto,
  }) async {
    isLoading.value = true;
    await signRepository.doSignOff(
      signUc: ucSign,
      pos: position,
      signOffPelabuhanFoto: signOffPelabuhanFoto,
      crewListFoto: crewListFoto,
      signOffImoFoto: signOffImoFoto,
    );
    isLoading.value = false;
  }
}
