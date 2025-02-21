import 'package:get/get.dart';
import 'package:mytrb/app/Repository/task_repository.dart';
import 'package:mytrb/app/modules/task_approval/controllers/task_approval_controller.dart';

class TaskApprovalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskRepository>(() => TaskRepository(), fenix: true);
    Get.lazyPut<TaskApprovalController>(() =>
        TaskApprovalController(taskRepository: Get.find<TaskRepository>()));
  }
}
