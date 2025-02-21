import 'package:get/get.dart';
import 'package:mytrb/app/Repository/report_repository.dart';
import 'package:mytrb/app/modules/report_route/controllers/report_route_controller.dart';

class ReportRouteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportRepository>(() => ReportRepository(), fenix: true);
    Get.lazyPut<ReportRouteController>(() => ReportRouteController(
          reportRepository: Get.find<ReportRepository>(),
        ));
  }
}
