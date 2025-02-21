import 'package:get/get.dart';
import 'package:mytrb/app/Repository/task_repository.dart';
import 'package:mytrb/app/modules/task/controllers/task_controller.dart';

class TaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskRepository>(() => TaskRepository(), fenix: true);
    Get.lazyPut<TaskController>(
        () => TaskController(taskRepository: Get.find<TaskRepository>()));
  }
}
