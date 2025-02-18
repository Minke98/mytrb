import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/modules/upload_requirements/controllers/upload_requirements_controller.dart';
import 'package:get/get.dart';

class UploadRequirementsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadRequirementsController>(
        () => UploadRequirementsController());
    Get.lazyPut<IndexController>(() => IndexController());
  }
}
