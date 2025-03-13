import 'dart:developer';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytrb/app/Repository/report_repository.dart';
import 'package:mytrb/app/Repository/sign_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/app/modules/report_task_add/controllers/report_task_add_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:mytrb/utils/auth_biometric.dart';
import 'package:mytrb/utils/get_device_id.dart';
import 'package:mytrb/utils/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportTaskAddFormController extends GetxController {
  final ReportRepository reportRepository;
  final ReportTaskAddController reportTaskAddController =
      Get.find<ReportTaskAddController>();
  ReportTaskAddFormController({required this.reportRepository});

  var status = Rx<ReportTaskFormStatus>(ReportTaskFormStatus.initial);
  var message = "".obs;
  var uploadFoto = Rx<XFile?>(null);
  var uploadFotoError = ''.obs;
  var isLoading = false.obs;
  var ucSign = ''.obs;
  var ucReport = ''.obs;
  var title = ''.obs;
  var monthNumber = 0.obs;
  var initText = "".obs;
  var quilError = false.obs;
  var count = 0.obs;
  final HtmlEditorController hcontroller = HtmlEditorController();
  var sch = 0.0.obs;
  final ImagePicker picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      ucSign.value = args['uc_sign'] ?? '';
      monthNumber.value = args['month_number'] ?? 1;
      title.value = args['title'];
      ucReport.value = args['uc_report'];
      print("REPORT_TASK_ADD_FORM: uc_sign=$ucSign, month_number=$monthNumber");
    } else {
      log("WARNING: Get.arguments is null!");
    }
  }

  void initialize() {
    status.value = ReportTaskFormStatus.ready;
  }

  Future<void> saveReportTaskForm({
    required String caption,
    required File foto,
    String? uc,
    String? ucAtt,
  }) async {
    try {
      bool isAuthenticated = await BiometricAuth.authenticateUser(
          'Use biometric authentication to login');
      if (!isAuthenticated) {
        EasyLoading.showError('Autentikasi biometrik gagal');
        return;
      }
      EasyLoading.show(status: 'Menyimpan...'); // Menampilkan loading

      status.value = ReportTaskFormStatus.saving;

      Map userData = await UserRepository.getLocalUser();
      if (userData['status'] == false) {
        throw "Tidak Bisa Menemukan User";
      }

      Map sign = await SignRepository.getDataFromUc(uc: ucSign.value);
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
        month: monthNumber.value,
        ucLecturer: ucLecturer,
        ucSign: ucSign.value,
        ucReport: ucReport.value,
        position: pos,
        deviceId: deviceId,
        ucAtt: ucAtt,
        uc: uc,
      );

      if (saveResult['status'] == false) {
        throw saveResult['message'];
      }

      status.value = ReportTaskFormStatus.success;

      Get.offNamed(Routes.REPORT_TASK_ADD, arguments: {
        "title": title.value,
        "uc_sign": ucSign.value,
        "uc_report": ucReport.value,
        "month_number": monthNumber.value
      });
      reportTaskAddController.initialize();
      Get.close(1);

      EasyLoading.dismiss(); // Menghilangkan loading setelah sukses
    } catch (e) {
      status.value = ReportTaskFormStatus.error;
      message.value = e.toString();
      EasyLoading.showError(e.toString()); // Menampilkan error
    }
  }

  Future<void> saveToPrefs() async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('title', title.value);
    pref.setInt('month', monthNumber.value);
    pref.setString('ucSign', ucSign.value);
    pref.setString('ucReport', ucReport.value);
  }
}

enum ReportTaskFormStatus { initial, ready, saving, success, error }
