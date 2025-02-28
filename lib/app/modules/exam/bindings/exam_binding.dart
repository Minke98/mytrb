import 'package:get/get.dart';
import 'package:mytrb/app/modules/exam/controllers/exam_controller.dart';

class ExamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExamController>(() =>
        ExamController(userRepository: Get.find(), examRepository: Get.find()));
  }
}
