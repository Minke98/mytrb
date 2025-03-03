import 'package:get/get.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/modules/sync/controllers/sync_controller.dart';

class SyncBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SyncController(syncRepository: Get.find()));
    Get.put<IndexController>(
      IndexController(
        signRepository: Get.find(),
      ),
      permanent: true,
    );
  }
}
