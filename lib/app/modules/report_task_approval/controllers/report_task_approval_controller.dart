import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytrb/app/components/constant.dart';
import 'package:mytrb/app/Repository/report_repository.dart';
import 'package:mytrb/app/modules/report_task_add/controllers/report_task_add_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';

class ReportTaskApprovalController extends GetxController {
  final ReportRepository reportRepository;
  ReportTaskApprovalController({required this.reportRepository});
  final ReportTaskAddController reportTaskAddController =
      Get.find<ReportTaskAddController>();
  final TextEditingController namaInstruktur = TextEditingController();
  final TextEditingController komentarInstruktur = TextEditingController();
  var uploadFoto = Rx<XFile?>(null);
  var uploadFotoError = ''.obs;
  RxBool quilError = false.obs;
  var isLoading = false.obs;
  var isSuccess = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;
  var approvalStatus = 1.obs;
  Rxn<int> selectedApproval = Rxn<int>();
  var isDropdownOpened = false.obs;
  var ucSign = ''.obs;
  var ucReport = ''.obs;
  var monthNumber = 0.obs;
  var isSubmitting = false.obs;
  var initText = "".obs;
  final HtmlEditorController hcontroller = HtmlEditorController();
  var sch = 0.0.obs;
  var htmlEditorHeight = 0.7.obs;
  final List<Approval> selection = [
    const Approval(value: 1, text: "Approved"),
    const Approval(value: 2, text: "Rejected"),
  ];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      ucSign.value = args['ucSign'] ?? '';
      monthNumber.value = args['month'] ?? 1;
      ucReport.value = args['ucReportList'];
      log("REPORT_TASK: uc_sign=$ucSign, month_number=$monthNumber");
    } else {
      log("WARNING: Get.arguments is null!");
    }
  }

  Future<void> saveApproval() async {
    try {
      EasyLoading.show(status: 'Processing...'); // Menampilkan loading

      isLoading.value = true;
      isSuccess.value = false;
      isError.value = false;
      errorMessage.value = '';
      var komentarInstruktur = await hcontroller.getText();

      Map res = await reportRepository.saveApproval(
        foto: File(uploadFoto.value!.path),
        month: monthNumber.value,
        approvalStatus: selectedApproval.value ?? 0,
        ucReportList: ucReport.value,
        namaInstruktur: namaInstruktur.text,
        komentarInstruktur: komentarInstruktur,
        ucSign: ucSign.value,
      );

      if (res['status'] == true) {
        isSuccess.value = true;
        EasyLoading.showSuccess('Approval Saved!');
        await Future.delayed(const Duration(seconds: 1));
        Get.offNamed(Routes.REPORT_TASK_ADD);
        reportTaskAddController.initialize();
        Get.close(1);
      } else {
        isError.value = true;
        errorMessage.value = res['message'];
        EasyLoading.showError(res['message']); // Notifikasi error
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = 'Something went wrong!';
      EasyLoading.showError('Something went wrong!'); // Notifikasi error umum
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss(); // Menghilangkan loading setelah selesai
    }
  }

  Future<bool> isFormValid() async {
    String komentar = await hcontroller.getText();
    return selectedApproval.value != null &&
        uploadFoto.value != null &&
        namaInstruktur.text.isNotEmpty &&
        komentar.isNotEmpty;
  }
}
