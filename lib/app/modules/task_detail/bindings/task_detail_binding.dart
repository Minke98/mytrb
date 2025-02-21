import 'package:get/get.dart';
import 'package:mytrb/app/modules/task_detail/controllers/task_detail_controller.dart';

class TaskDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskDetailController>(() => TaskDetailController());
  }
}
