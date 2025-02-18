import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/report_evaluation/controllers/report_evaluation_controller.dart';

class ReportEvaluationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportEvaluationController>(() => ReportEvaluationController());
    Get.lazyPut<IndexController>(() => IndexController());
  }
}
