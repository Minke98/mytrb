import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytrb/app/Repository/task_repository.dart';
import 'package:mytrb/app/components/constant.dart';
import 'package:mytrb/app/modules/task_checklist/controllers/task_checklist_controller.dart';
import 'package:mytrb/utils/location.dart';

class TaskApprovalController extends GetxController {
  final TaskRepository taskRepository;

  TaskApprovalController({required this.taskRepository});
  final TaskChecklistController taskChecklistController =
      Get.find<TaskChecklistController>();
  var isLoading = false.obs;
  var message = "".obs;
  var approvalData = {}.obs;
  var initText = "".obs;
  Rxn<int> selectedApproval = Rxn<int>();
  var isDropdownOpened = false.obs;
  final HtmlEditorController hcontroller = HtmlEditorController();
  final TextEditingController namaInstruktur = TextEditingController();
  // var taskUc = ''.obs;
  // var taskName = ''.obs;
  var taskUc = Rxn<String>();
  var taskName = Rxn<String>();

  var uploadFoto = Rx<XFile?>(null);
  var uploadFotoError = ''.obs;
  var quilError = false.obs;
  final List<Approval> selection = [
    const Approval(value: 1, text: "Approved"),
    const Approval(value: 2, text: "Rejected"),
  ];
  var isSubmitting = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      taskUc.value = args["task_uc"];
      taskName.value = args["task_name"];
    } else {
      log("WARNING: Get.arguments is null!");
    }
  }

  Future<void> saveApproval() async {
    try {
      EasyLoading.show(status: "Mencari Lokasi Anda ...");

      Map pos = await Location.getLocation();
      if (pos['status'] == false) {
        EasyLoading.showError(pos['message']);
        return;
      }

      var komentarInstruktur = await hcontroller.getText();

      EasyLoading.show(status: "Menyimpan Approval ...");

      Map save = await taskRepository.saveApproval(
        instFoto: File(uploadFoto.value!.path),
        namaInstruktur: namaInstruktur.text,
        komentar: komentarInstruktur,
        statusApproval: selectedApproval.value ?? 0,
        taskUc: taskUc.value ?? '',
        pos: pos['position'],
      );

      if (save['status'] == true) {
        approvalData.value = save['data'] ?? {};
        taskChecklistController.updateSingleTask(taskUc.value ?? '');
        Get.close(1);
        EasyLoading.showSuccess("Approval berhasil disimpan!");
      } else {
        EasyLoading.showError(save['message']);
      }
    } catch (e) {
      EasyLoading.showError("Terjadi kesalahan: $e");
    } finally {
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
