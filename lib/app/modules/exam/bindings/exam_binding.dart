import 'package:get/get.dart';
import 'package:mytrb/app/Repository/exam_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/app/modules/exam/controllers/exam_controller.dart';

class ExamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRepository>(() => UserRepository(), fenix: true);
    Get.lazyPut<ExamRepository>(() => ExamRepository(), fenix: true);
    Get.lazyPut<ExamController>(() => ExamController(
          userRepository: Get.find<UserRepository>(),
          examRepository: Get.find<ExamRepository>(),
        ));
  }
}
