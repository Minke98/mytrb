import 'dart:io';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mytrb/app/Repository/report_repository.dart';
import 'package:mytrb/app/Repository/sign_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/utils/get_device_id.dart';
import 'package:mytrb/utils/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportTaskAddController extends GetxController {
  final ReportRepository reportRepository;
  ReportTaskAddController({required this.reportRepository});

  var reportItem = <Map>[].obs;
  var reportStatus = Rxn<Map>();
  var allowModify = true.obs;
  var isLoading = false.obs;

  void initialize(
      {required String month,
      required String ucReportList,
      required String ucSign,
      required int epoch}) async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 150));
    List<Map> items = await reportRepository.getReportItem(
        month: month, ucReportList: ucReportList, ucSign: ucSign);
    reportItem.assignAll(items);
    if (items.isNotEmpty) {
      reportStatus.value = items[0];
    }
    final prefs = await SharedPreferences.getInstance();
    await UserRepository.getLocalUser(useAlternate: true);
    allowModify.value = prefs.getBool("modifyTask") ?? true;
    isLoading.value = false;
  }

  Future<void> saveFoto({
    required String caption,
    required File foto,
    required int month,
    required String ucSign,
    required String ucReport,
    required String uc,
    required String ucAtt,
  }) async {
    try {
      Map userData = await UserRepository.getLocalUser();
      if (userData['status'] == false) throw "Tidak Bisa Menemukan User";

      Map sign = await SignRepository.getDataFromUc(uc: ucSign);
      if (sign['status'] == false) throw "Tidak Bisa Menemukan Sign Data";
      String ucLecturer = sign['data']['uc_lecturer'];

      Position? pos;
      if (uc.isEmpty) {
        Map loc = await Location.getLocation();
        if (loc['status'] == false) throw "Tidak Bisa Menemukan Lokasi Data";
        pos = loc['position'];
      }

      String deviceId = await getUniqueDeviceId();
      Map saveFoto = await reportRepository.saveImage(
          caption: caption,
          foto: foto,
          month: month,
          ucLecturer: ucLecturer,
          ucSign: ucSign,
          ucReport: ucReport,
          position: pos,
          deviceId: deviceId,
          ucAtt: ucAtt,
          uc: uc.isEmpty ? null : uc);

      if (saveFoto['status'] == false) throw saveFoto['message'];
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
