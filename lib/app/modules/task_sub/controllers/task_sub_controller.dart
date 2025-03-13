import 'dart:developer';

import 'package:get/get.dart';
import 'package:mytrb/app/Repository/task_repository.dart';

class TaskSubController extends GetxController {
  final TaskRepository taskRepository;
  TaskSubController({required this.taskRepository});

  var subCompetency = <Map>[].obs;
  var isLoading = false.obs;
  var ucCompetency = ''.obs;
  var label = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      ucCompetency.value = args['uc_competency'] ?? '';
      label.value = args['label'] ?? '';
      print("TASK: ucCompetency=$ucCompetency, label=$label");
    } else {
      log("WARNING: Get.arguments is null!");
    }
    initSubTask();
  }

  void initSubTask() async {
    isLoading.value = true;
    List<Map>? resSubCompetency = await taskRepository.getSubListCompetency(
        ucCompetency: ucCompetency.value);
    subCompetency.value = resSubCompetency ?? [];
    isLoading.value = false;
  }
}
