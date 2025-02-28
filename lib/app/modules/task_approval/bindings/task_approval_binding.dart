import 'package:get/get.dart';
import 'package:mytrb/app/modules/task_approval/controllers/task_approval_controller.dart';

class TaskApprovalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskApprovalController>(
        () => TaskApprovalController(taskRepository: Get.find()));
  }
}
