import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mytrb/app/Repository/report_repository.dart';
import 'package:mytrb/app/Repository/sign_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/utils/get_device_id.dart';
import 'package:mytrb/utils/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class ReportTaskAddController extends GetxController {
  final ReportRepository reportRepository;
  ReportTaskAddController({required this.reportRepository});

  var reportItem = <Map>[].obs;
  var sch = 0.obs;
  var reportStatus = Rxn<Map>();
  var allowModify = true.obs;
  var isLoading = false.obs;
  var isReady = false.obs;
  var title = ''.obs;
  var komentar = ''.obs;
  var showInstructorImage = false.obs;
  var showInstructorName = false.obs;
  var showComment = false.obs;
  var showApprovalButton = true.obs;
  var showAddButton = true.obs;
  var menuVisible = false.obs;
  var lecturerApprovalText = "Pending".obs;
  var instructorApprovalText = "Pending".obs;
  var instructorName = "".obs;
  var instructorImage = "".obs;
  var flexValue = 2;
  var flexImageValue = 1;
  var imageHeight = 100.0;
  var webContainerHeight = 200.0;
  var ucSign = ''.obs;
  var ucReport = ''.obs;
  var monthNumber = 0.obs;
  var approveIndex = 0.obs;
  var lectApproveIndex = 0.obs;
  late final WebViewController webViewController;
  late Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  var columnChilds = <Widget>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      ucSign.value = args['uc_sign'] ?? '';
      monthNumber.value = args['month_number'] ?? 1;
      title.value = args['title'];
      ucReport.value = args['uc_report'];
      print("REPORT_TASK: uc_sign=$ucSign, month_number=$monthNumber");
    } else {
      log("WARNING: Get.arguments is null!");
    }
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..enableZoom(false);
    gestureRecognizers = {Factory(() => EagerGestureRecognizer())};
    initialize();
  }

  void initialize() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 150));
    List<Map> items = await reportRepository.getReportItem(
        month: monthNumber.value,
        ucReportList: ucReport.value,
        ucSign: ucSign.value);
    reportItem.assignAll(items);
    if (items.isNotEmpty) {
      reportStatus.value = items[0];
      approveIndex.value = reportStatus.value?['app_inst_status'] ?? '';
      lectApproveIndex.value = reportStatus.value?['app_lect_status'] ?? '';
    }
    final prefs = await SharedPreferences.getInstance();
    await UserRepository.getLocalUser(useAlternate: true);
    allowModify.value = prefs.getBool("modifyTask") ?? true;
    isReady.value = true;
    isLoading.value = false;
    menuVisible.value = false;
  }

  Future<void> saveFoto({
    required String caption,
    required File foto,
    required int month,
    required String ucSign,
    required String ucReport,
    required String uc,
    required String ucAtt,
  }) async {
    try {
      Map userData = await UserRepository.getLocalUser();
      if (userData['status'] == false) throw "Tidak Bisa Menemukan User";

      Map sign = await SignRepository.getDataFromUc(uc: ucSign);
      if (sign['status'] == false) throw "Tidak Bisa Menemukan Sign Data";
      String ucLecturer = sign['data']['uc_lecturer'];

      Position? pos;
      if (uc.isEmpty) {
        Map loc = await Location.getLocation();
        if (loc['status'] == false) throw "Tidak Bisa Menemukan Lokasi Data";
        pos = loc['position'];
      }

      String deviceId = await getUniqueDeviceId();
      Map saveFoto = await reportRepository.saveImage(
          caption: caption,
          foto: foto,
          month: month,
          ucLecturer: ucLecturer,
          ucSign: ucSign,
          ucReport: ucReport,
          position: pos,
          deviceId: deviceId,
          ucAtt: ucAtt,
          uc: uc.isEmpty ? null : uc);

      if (saveFoto['status'] == false) throw saveFoto['message'];
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void toggleMenuVisibility() {
    menuVisible.value = !menuVisible.value;
  }

  @override
  void onClose() {
    menuVisible.value = false; // Pastikan menu tertutup saat kembali
    super.onClose();
  }
}
