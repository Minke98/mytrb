import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:mytrb/app/Repository/logbook_repository.dart';

class LogbookApprovalController extends GetxController {
  final LogBookRepository logBookRepository;

  LogbookApprovalController({required this.logBookRepository});

  var isLoading = false.obs;
  var isSaving = false.obs;
  var errorMessage = ''.obs;
  var logData = {}.obs;

  Future<void> reset() async {
    log("LOG DATA Reset");
    logData.clear();
    errorMessage.value = '';
  }

  Future<void> prepare(String uc) async {
    isLoading.value = true;
    log("LOG DATA load Uc $uc");

    Map data = await logBookRepository.loadOne(uc: uc);

    if (data['status'] == false) {
      errorMessage.value = "Data not found";
    } else {
      logData.value = data['data'];
      log("LOG DATA controller $logData");
    }

    isLoading.value = false;
  }

  Future<void> save({
    required String uc,
    required File foto,
    required int status,
    required String namaInstruktur,
    required String komentar,
  }) async {
    isSaving.value = true;
    log("save controller $uc");

    Map ret = await logBookRepository.saveApproval(
      uc: uc,
      foto: foto,
      status: status,
      namaInstruktur: namaInstruktur,
      komentar: komentar,
    );

    if (ret['status'] == false) {
      errorMessage.value = ret['message'];
    } else {
      logData.clear();
    }

    isSaving.value = false;
  }
}
