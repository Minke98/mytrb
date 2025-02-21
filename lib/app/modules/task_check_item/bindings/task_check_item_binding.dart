import 'package:get/get.dart';
import 'package:mytrb/app/Repository/task_repository.dart';
import 'package:mytrb/app/modules/task_check_item/controllers/task_check_item_controller.dart';

class TaskCheckItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskRepository>(() => TaskRepository(), fenix: true);
    Get.lazyPut<TaskCheckItemController>(() =>
        TaskCheckItemController(taskRepository: Get.find<TaskRepository>()));
  }
}
