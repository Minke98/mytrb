import 'dart:io';
import 'package:get/get.dart';
import 'package:mytrb/app/Repository/task_repository.dart';
import 'package:mytrb/utils/location.dart';

class TaskApprovalController extends GetxController {
  final TaskRepository taskRepository;

  TaskApprovalController({required this.taskRepository});

  var isLoading = false.obs;
  var message = "".obs;
  var approvalData = {}.obs;

  void initiateTaskApproval() {
    update();
  }

  Future<void> saveApproval({
    required File instFoto,
    required String namaInstruktur,
    required String komentar,
    required int statusApproval,
    required String taskUc,
  }) async {
    isLoading.value = true;
    message.value = "Mencari Lokasi Anda ...";

    Map pos = await Location.getLocation();
    if (pos['status'] == false) {
      message.value = pos['message'];
      isLoading.value = false;
      return;
    }

    message.value = "Menyimpan Approval ...";
    Map save = await taskRepository.saveApproval(
      instFoto: instFoto,
      namaInstruktur: namaInstruktur,
      komentar: komentar,
      statusApproval: statusApproval,
      taskUc: taskUc,
      pos: pos['position'],
    );

    if (save['status'] == true) {
      approvalData.value = save['data'] ?? {};
    } else {
      message.value = save['message'];
    }

    isLoading.value = false;
  }
}
