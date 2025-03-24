import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:mytrb/app/Repository/logbook_repository.dart';
import 'package:mytrb/app/modules/logbook/controllers/logbook_controller.dart';
import 'package:mytrb/utils/auth_biometric.dart';
import 'package:mytrb/utils/dialog.dart';
import 'package:mytrb/utils/location.dart';

class LogbookAddController extends GetxController {
  final LogBookRepository logBookRepository;

  LogbookAddController({required this.logBookRepository});
  final LogbookController logbookController = Get.find<LogbookController>();
  var isLoading = false.obs;
  var isSaving = false.obs;
  var dateObj = Rxn<DateTime>();
  var dateText = ''.obs;
  var html = ''.obs;
  var isFormValid = false.obs;
  var uc = Rxn<String>();
  var isSubmitting = false.obs;
  final TextEditingController dateController = TextEditingController();
  final HtmlEditorController hcontroller = HtmlEditorController();
  var initText = "".obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      uc.value = args['uc']; // Set ke null jika args['uc'] tidak ada
      log("REPORT_TASK: uc=${uc.value}");
    } else {
      log("WARNING: Get.arguments is null!");
      uc.value = null; // Pastikan null untuk operasi create
    }
    prepare();
  }

  void prepare() async {
    isLoading.value = true;
    log("preparing ${uc.value}");

    if (uc.value != null && uc.value!.isNotEmpty) {
      Map<String, dynamic> data =
          await logBookRepository.loadOne(uc: uc.value!);
      if (data['status'] == false) {
        isLoading.value = false;
        Get.snackbar("Error", "Data tidak ditemukan");
        return;
      } else {
        Map logData = data['data'];
        dateObj.value = logData['date_parsed'];
        dateText.value = logData['log_date'];
        html.value = logData['log_activity'];
        uc.value = uc.value;
      }
    } else {
      dateObj.value = null;
      dateText.value = "";
      html.value = "";
      uc.value = null; // Pastikan null untuk operasi create
    }
    isLoading.value = false;
  }

  Future<void> submit() async {
    bool isAuthenticated = await BiometricAuth.authenticateUser(
        'Use biometric authentication to login');
    if (!isAuthenticated) {
      EasyLoading.showError('Autentikasi biometrik gagal');
      return;
    }
    EasyLoading.show(status: 'Processing...');

    Map getPos = await Location.getLocation();
    if (getPos['status'] == false) {
      EasyLoading.dismiss();
      if (Get.context != null) {
        MyDialog.showError(Get.context!, getPos['message']);
      }
      return;
    }

    var formattedDate = DateFormat('yyyy-MM-dd').format(dateObj.value!);
    Position pos = getPos['position'];
    String keterangan = await hcontroller.getText();

    Map ret = await logBookRepository.save(
      date: formattedDate,
      keterangan: keterangan,
      pos: pos,
      uc: uc.value, // Kirim null untuk create
    );

    EasyLoading.dismiss();

    if (ret['status'] == true) {
      EasyLoading.showSuccess("Logbook berhasil disimpan");
      Get.back();
      logbookController.initLogBook();
    } else {
      EasyLoading.showError(ret['message']);
    }
  }

  Future<void> validateForm() async {
    String keterangan = await hcontroller.getText();
    isFormValid.value = dateObj.value != null && keterangan.isNotEmpty;
  }
}
