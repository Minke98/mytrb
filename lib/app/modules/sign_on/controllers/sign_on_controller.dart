import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mytrb/app/Repository/sign_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/app/data/models/type_vessel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class SignController extends GetxController {
  final SignRepository signRepository;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<TypeVessel> vesselList = <TypeVessel>[].obs;

  SignController({required this.signRepository});

  @override
  void onInit() {
    super.onInit();
    prepareSignForm();
  }

  Future<void> prepareSignForm() async {
    isLoading.value = true;
    try {
      Map vessel = await signRepository.getVesselType();
      vesselList.assignAll(
          (vessel['vessel'] as List).map((e) => TypeVessel.fromJson(e)));
    } catch (e) {
      errorMessage.value = 'Gagal mengambil data kapal';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitSignForm({
    required DateTime signOnDate,
    required String typeVesselUc,
    required String vesselName,
    required String companyName,
    required String imoNumber,
    required String mmsiNumber,
    required String ucLecturer,
    required Position position,
    required File mutasiOnFoto,
    required File signOnFoto,
    required File imoFoto,
    required File crewListFoto,
    required File bukuPelautFoto,
  }) async {
    isSaving.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      var user =
          await UserRepository.getLocalUser(uc: prefs.getString("userUc"));
      if (user['status'] != true) throw "User tidak ditemukan";
      var userData = user['data'];
      String signOnDbFormat = DateFormat('yyyy-MM-dd').format(signOnDate);

      bool res = await signRepository.doSignOn(
        signOnDate: signOnDbFormat,
        seafarerCode: userData['seafarer_code'],
        ucTypeVessel: typeVesselUc,
        vesselName: vesselName,
        companyName: companyName,
        imoNumber: imoNumber,
        mmsiNumber: mmsiNumber,
        ucLecturer: ucLecturer,
        signOnLat: position.latitude,
        signOnLon: position.longitude,
        mutasiOnFoto: mutasiOnFoto,
        signOnFoto: signOnFoto,
        imoFoto: imoFoto,
        crewListFoto: crewListFoto,
        bukuPelautFoto: bukuPelautFoto,
      );
      if (!res) throw "Gagal melakukan sign";
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isSaving.value = false;
    }
  }
}
