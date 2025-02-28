import 'package:get/get.dart';
import 'package:mytrb/app/modules/task_sub/controllers/task_sub_controller.dart';

class TaskSubBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskSubController>(
        () => TaskSubController(taskRepository: Get.find()));
  }
}
