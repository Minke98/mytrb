import 'dart:async';
import 'package:get/get.dart';
import 'package:mytrb/app/Repository/sync_repository.dart';

class SyncController extends GetxController {
  final SyncRepository syncRepository;
  SyncController({required this.syncRepository});

  var syncStatus = RxString("");
  var isSyncing = false.obs;

  Future<void> startSyncing() async {
    isSyncing.value = true;
    syncStatus.value = "Syncing";

    StreamController<String> controller = StreamController<String>();
    StreamSubscription streamSubscription = controller.stream.listen((event) {
      syncStatus.value = event;
    });

    Map syncRes = await syncRepository.doSync(stream: controller);

    if (syncRes['status'] == false) {
      syncStatus.value = syncRes['message'];
    } else {
      syncStatus.value = "Sync Completed";
      Future.delayed(
          const Duration(seconds: 1), () => Get.offAllNamed('/home'));
    }

    streamSubscription.cancel();
    controller.close();
    isSyncing.value = false;
  }
}
