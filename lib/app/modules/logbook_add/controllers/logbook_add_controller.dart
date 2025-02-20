import 'dart:developer';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mytrb/app/Repository/logbook_repository.dart';

class LogbookAddController extends GetxController {
  final LogBookRepository logBookRepository;

  LogbookAddController({required this.logBookRepository});

  var isLoading = false.obs;
  var isSaving = false.obs;
  var dateObj = Rxn<DateTime>();
  var dateText = ''.obs;
  var html = ''.obs;
  var uc = RxnString();

  void prepare({String? uc}) async {
    isLoading.value = true;
    log("preparing $uc");

    if (uc != null) {
      Map<String, dynamic> data = await logBookRepository.loadOne(uc: uc);
      if (data['status'] == false) {
        isLoading.value = false;
        Get.snackbar("Error", "Data tidak ditemukan");
        return;
      } else {
        Map logData = data['data'];
        dateObj.value = logData['date_parsed'];
        dateText.value = logData['log_date'];
        html.value = logData['log_activity'];
        this.uc.value = uc;
      }
    } else {
      dateObj.value = null;
      dateText.value = "";
      html.value = "";
      this.uc.value = null;
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
      uc: uc,
    );

    if (ret['status'] == true) {
      Get.snackbar("Success", "Logbook berhasil disimpan");
    } else {
      Get.snackbar("Failed", ret['message']);
    }
    isSaving.value = false;
  }
}
