import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/modules/training/controllers/training_controller.dart';
import 'package:mytrb/app/modules/upload_requirements/controllers/upload_requirements_controller.dart';
import 'package:get/get.dart';

class TrainingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrainingController>(() => TrainingController());
    Get.lazyPut<IndexController>(() => IndexController());
    Get.lazyPut<UploadRequirementsController>(
        () => UploadRequirementsController());
  }
}
