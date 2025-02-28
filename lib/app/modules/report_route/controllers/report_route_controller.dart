import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/Repository/report_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/utils/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportRouteController extends GetxController {
  final ReportRepository reportRepository;

  ReportRouteController({required this.reportRepository});

  final TextEditingController locationController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var routes = <dynamic>[].obs;
  var allowModify = true.obs;
  var errorMessage = ''.obs;
  var ucSign = ''.obs;
  var monthNumber = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      ucSign.value = args['uc_sign'] ?? '';
      monthNumber.value = args['month_number'] ?? 1;
      print("REPORT_ROUTE: uc_sign=$ucSign, month_number=$monthNumber");
    } else {
      log("WARNING: Get.arguments is null!");
    }
    prepareReportRoute();
  }

  Future<void> prepareReportRoute() async {
    isLoading.value = true;

    try {
      List routesData = List.from(await reportRepository.getRoutes(
          month: monthNumber.value, ucSign: ucSign.value));

      await UserRepository.getLocalUser(useAlternate: true);
      final prefs = await SharedPreferences.getInstance();
      allowModify.value = prefs.getBool("modifyTask") ?? true;

      routes.assignAll(routesData);
    } catch (e) {
      errorMessage.value = "Gagal memuat data rute";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveRoute() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    EasyLoading.show(status: 'Mencari Lokasi Anda');

    try {
      Map location = await Location.getLocation();
      if (location['status'] == true) {
        EasyLoading.show(status: 'Menyimpan Rute');

        Map saveLocation = await reportRepository.addRoute(
          month: monthNumber.value,
          locationName: locationController.text,
          position: location['position'],
          ucSign: ucSign.value,
        );

        if (saveLocation['status'] == true) {
          List updatedRoutes = List.from(await reportRepository.getRoutes(
              month: monthNumber.value, ucSign: ucSign.value));

          routes.assignAll(updatedRoutes);
          EasyLoading.dismiss();
        } else {
          EasyLoading.showError(saveLocation['message']);
        }
      } else {
        EasyLoading.showError(location['message']);
      }
    } catch (e) {
      EasyLoading.showError("Gagal menyimpan rute");
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }
}
