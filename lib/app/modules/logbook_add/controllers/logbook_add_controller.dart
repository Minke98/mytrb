import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:mytrb/app/Repository/logbook_repository.dart';

class LogbookAddController extends GetxController {
  final LogBookRepository logBookRepository;

  LogbookAddController({required this.logBookRepository});

  var isLoading = false.obs;
  var isSaving = false.obs;
  var dateObj = Rxn<DateTime>();
  var dateText = ''.obs;
  var html = ''.obs;
  var uc = Rxn<String>(); // Inisialisasi sebagai nullable
  final TextEditingController dateController = TextEditingController();
  final HtmlEditorController hcontroller = HtmlEditorController();
  var initText = "".obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      uc.value = args['uc'] ?? null; // Set ke null jika args['uc'] tidak ada
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

  Future<void> submit({
    required String date,
    required String keterangan,
    required Position pos,
    String? uc,
  }) async {
    isSaving.value = true;
    Map ret = await logBookRepository.save(
      date: date,
      keterangan: keterangan,
      pos: pos,
      uc: uc, // Kirim null untuk create
    );

    if (ret['status'] == true) {
      Get.snackbar("Success", "Logbook berhasil disimpan");
    } else {
      Get.snackbar("Failed", ret['message']);
    }
    isSaving.value = false;
  }
}
