import 'package:get/get.dart';
import 'package:mytrb/app/modules/report_route/controllers/report_route_controller.dart';

class ReportRouteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportRouteController>(
        () => ReportRouteController(reportRepository: Get.find()));
  }
}
