import 'package:get/get.dart';
import 'package:mytrb/app/Repository/task_repository.dart';
import 'package:mytrb/app/modules/task_sub/controllers/task_sub_controller.dart';

class TaskSubBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskRepository>(() => TaskRepository(), fenix: true);
    Get.lazyPut<TaskSubController>(
        () => TaskSubController(taskRepository: Get.find<TaskRepository>()));
  }
}
