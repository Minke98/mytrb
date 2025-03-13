import 'package:get/get.dart';
import 'package:mytrb/app/modules/task_approval/controllers/task_approval_controller.dart';
import 'package:mytrb/app/modules/task_checklist/controllers/task_checklist_controller.dart';

class TaskApprovalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskApprovalController>(
      () => TaskApprovalController(
        taskRepository: Get.find(),
      ),
    );
    Get.lazyPut<TaskChecklistController>(
      () => TaskChecklistController(
        taskRepository: Get.find(),
      ),
    );
  }
}
