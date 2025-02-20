import 'dart:developer';
import 'package:get/get.dart';
import 'package:mytrb/app/Repository/logbook_repository.dart';

class LogbookController extends GetxController {
  final LogBookRepository logBookRepository;

  LogbookController({required this.logBookRepository});

  var logbookList = [].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var approvalMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    prepare();
  }

  Future<void> prepare() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      Map ret = await logBookRepository.load(sort: "DESC");
      if (ret['status'] == false) {
        errorMessage.value = ret['message'];
      } else {
        if (ret['data'] is List && ret['data'].isNotEmpty) {
          logbookList.assignAll(ret['data']);
        } else {
          logbookList.clear();
        }
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat memuat data';
    } finally {
      isLoading.value = false;
      log("Logbook Loaded: ${logbookList.length} items");
    }
  }

  void toggleApprovalMode(bool value) {
    approvalMode.value = value;
  }
}
