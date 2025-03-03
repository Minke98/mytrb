import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/Repository/sync_repository.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';

class SyncController extends GetxController {
  final SyncRepository syncRepository;
  SyncController({required this.syncRepository});
  final IndexController indexController = Get.find<IndexController>();

  var syncStatus = RxString("");
  var isSyncing = false.obs;

  Future<void> startSyncing() async {
    isSyncing.value = true;

    // Menampilkan loading indicator
    EasyLoading.show(status: "Syncing...");

    Map syncRes = await syncRepository.doSync();

    EasyLoading.dismiss(); // Menutup loading setelah proses selesai

    if (syncRes['status'] == false) {
      syncStatus.value = syncRes['message'];

      // Menampilkan toast error
      EasyLoading.showError(syncRes['message']);
    } else {
      syncStatus.value = "Sync Completed";

      // Menampilkan toast sukses
      EasyLoading.showSuccess("Sync Completed");
      indexController.isNeedSync.value = false;

      // Tunggu sebentar sebelum navigasi ulang ke home
      Future.delayed(const Duration(seconds: 1), () {
        Get.offNamed(Routes.INDEX);
      });
    }

    isSyncing.value = false;
  }
}
