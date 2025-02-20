import 'dart:io';
import 'package:get/get.dart';
import 'package:mytrb/app/Repository/report_repository.dart';

class ReportTaskApprovalController extends GetxController {
  final ReportRepository reportRepository;

  ReportTaskApprovalController({required this.reportRepository});

  var isLoading = false.obs;
  var isSuccess = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

  void initialize() {
    isLoading.value = false;
    isSuccess.value = false;
    isError.value = false;
    errorMessage.value = '';
  }

  Future<void> saveApproval({
    required File foto,
    required int month,
    required int approvalStatus,
    required String ucReport,
    required String namaInstruktur,
    required String komentarInstruktur,
    required String ucSign,
  }) async {
    isLoading.value = true;
    isSuccess.value = false;
    isError.value = false;
    errorMessage.value = '';

    Map res = await reportRepository.saveApproval(
      foto: foto,
      month: month,
      approvalStatus: approvalStatus,
      ucReportList: ucReport,
      namaInstruktur: namaInstruktur,
      komentarInstruktur: komentarInstruktur,
      ucSign: ucSign,
    );

    if (res['status'] == true) {
      isSuccess.value = true;
    } else {
      isError.value = true;
      errorMessage.value = res['message'];
    }

    isLoading.value = false;
  }
}
