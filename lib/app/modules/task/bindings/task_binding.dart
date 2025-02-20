import 'package:get/get.dart';
import 'package:mytrb/app/Repository/task_repository.dart';
import 'package:mytrb/app/modules/task/controllers/task_controller.dart';

class TaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TaskRepository(), fenix: true);
    Get.lazyPut(
      () => TaskController(taskRepository: Get.find()),
    );
  }
}
