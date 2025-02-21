import 'package:get/get.dart';
import 'package:mytrb/app/Repository/task_repository.dart';
import 'package:mytrb/app/modules/task_checklist/controllers/task_checklist_controller.dart';

class TaskChecklistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskRepository>(() => TaskRepository(), fenix: true);
    Get.lazyPut<TaskChecklistController>(() =>
        TaskChecklistController(taskRepository: Get.find<TaskRepository>()));
  }
}
