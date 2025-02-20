import 'package:get/get.dart';
import 'package:mytrb/app/Repository/sync_repository.dart';
import 'package:mytrb/app/modules/sync/controllers/sync_controller.dart';

class SyncBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SyncRepository(), fenix: true);
    Get.lazyPut(() => SyncController(syncRepository: Get.find()));
  }
}
