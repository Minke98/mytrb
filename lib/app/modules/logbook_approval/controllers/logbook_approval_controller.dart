import 'dart:developer';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytrb/app/Repository/logbook_repository.dart';
import 'package:mytrb/app/components/constant.dart';
import 'package:mytrb/app/modules/logbook/controllers/logbook_controller.dart';

class LogbookApprovalController extends GetxController {
  final LogBookRepository logBookRepository;

  LogbookApprovalController({required this.logBookRepository});
  final LogbookController logbookController = Get.find<LogbookController>();
  var isLoading = false.obs;
  var isSaving = false.obs;
  var errorMessage = ''.obs;
  var logData = {}.obs;
  var uc = Rxn<String>();
  Rxn<int> selectedApproval = Rxn<int>();
  var isDropdownOpened = false.obs;
  var uploadFoto = Rx<XFile?>(null);
  var uploadFotoError = ''.obs;
  final List<Approval> selection = [
    const Approval(value: 1, text: "Approved"),
    const Approval(value: 2, text: "Rejected"),
  ];
  final TextEditingController namaInstruktur = TextEditingController();
  var initText = "".obs;
  final HtmlEditorController hcontroller = HtmlEditorController();
  var isSubmitting = false.obs;

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

  Future<void> reset() async {
    log("LOG DATA Reset");
    logData.clear();
    errorMessage.value = '';
  }

  Future<void> prepare() async {
    isLoading.value = true;
    log("LOG DATA load Uc $uc");

    Map data = await logBookRepository.loadOne(uc: uc.value!);

    if (data['status'] == false) {
      errorMessage.value = "Data not found";
    } else {
      logData.value = data['data'];
      log("LOG DATA controller $logData");
    }

    isLoading.value = false;
  }

  Future<void> save() async {
    isSaving.value = true;
    EasyLoading.show(status: 'Menyimpan...');

    try {
      log("save controller $uc");
      var komentarInstruktur = await hcontroller.getText();
      Map ret = await logBookRepository.saveApproval(
        uc: uc.value!,
        foto: File(uploadFoto.value!.path),
        status: selectedApproval.value ?? 0,
        namaInstruktur: namaInstruktur.text,
        komentar: komentarInstruktur,
      );

      if (ret['status'] == false) {
        errorMessage.value = ret['message'];
        EasyLoading.showError(ret['message']);
      } else {
        logData.clear();
        EasyLoading.showSuccess('Berhasil disimpan');
        Get.close(1);
        logbookController.initLogBook();
      }
    } catch (e) {
      EasyLoading.showError('Terjadi kesalahan');
      log('Save Error: $e');
    } finally {
      isSaving.value = false;
      EasyLoading.dismiss();
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
