import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/Repository/report_repository.dart';
import 'package:mytrb/app/Repository/sign_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/utils/get_device_id.dart';
import 'package:mytrb/utils/location.dart';

class ReportTaskFormController extends GetxController {
  final ReportRepository reportRepository;

  ReportTaskFormController({required this.reportRepository});

  var status = Rx<ReportTaskFormStatus>(ReportTaskFormStatus.initial);
  var message = "".obs;

  void initialize() {
    status.value = ReportTaskFormStatus.ready;
  }

  Future<void> saveReportTaskForm({
    required String caption,
    required File foto,
    required int month,
    required String ucSign,
    required String ucReport,
    String? uc,
    String? ucAtt,
  }) async {
    try {
      status.value = ReportTaskFormStatus.saving;

      Map userData = await UserRepository.getLocalUser();
      if (userData['status'] == false) {
        throw "Tidak Bisa Menemukan User";
      }

      Map sign = await SignRepository.getDataFromUc(uc: ucSign);
      if (sign['status'] == false) {
        throw "Tidak Bisa Menemukan Sign Data";
      }

      String ucLecturer = sign['data']['uc_lecturer'];
      Position? pos;

      if (uc == null || uc.isEmpty) {
        Map loc = await Location.getLocation();
        if (loc['status'] == false) {
          throw "Tidak Bisa Menemukan Lokasi Data";
        }
        pos = loc['position'];
      }

      String deviceId = await getUniqueDeviceId();

      Map saveResult = await reportRepository.addTugas(
        caption: caption,
        foto: foto,
        month: month,
        ucLecturer: ucLecturer,
        ucSign: ucSign,
        ucReport: ucReport,
        position: pos,
        deviceId: deviceId,
        ucAtt: ucAtt,
        uc: uc,
      );

      if (saveResult['status'] == false) {
        throw saveResult['message'];
      }

      status.value = ReportTaskFormStatus.success;
    } catch (e) {
      status.value = ReportTaskFormStatus.error;
      message.value = e.toString();
    }
  }
}

enum ReportTaskFormStatus { initial, ready, saving, success, error }
