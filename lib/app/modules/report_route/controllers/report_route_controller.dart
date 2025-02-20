import 'package:get/get.dart';
import 'package:mytrb/app/Repository/report_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/utils/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportRouteController extends GetxController {
  final ReportRepository reportRepository;

  ReportRouteController({required this.reportRepository});

  var isLoading = false.obs;
  var routes = <Map<String, dynamic>>[].obs;
  var allowModify = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> prepareReportRoute(
      {required int month, required String ucSign}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      List<Map<String, dynamic>> routesData = List<Map<String, dynamic>>.from(
          await reportRepository.getRoutes(month: month, ucSign: ucSign));

      await UserRepository.getLocalUser(useAlternate: true);
      final prefs = await SharedPreferences.getInstance();
      allowModify.value = prefs.getBool("modifyTask") ?? true;

      routes.assignAll(routesData);
    } catch (e) {
      errorMessage.value = "Gagal memuat data rute";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveRoute(
      {required int month,
      required String locationName,
      required String ucSign}) async {
    isLoading.value = true;
    errorMessage.value = 'Mencari Lokasi Anda';

    try {
      Map<String, dynamic> location = await Location.getLocation();
      if (location['status'] == true) {
        errorMessage.value = 'Menyimpan Rute';
        Map<String, dynamic> saveLocation = await reportRepository.addRoute(
          month: month,
          locationName: locationName,
          position: location['position'],
          ucSign: ucSign,
        );

        if (saveLocation['status'] == true) {
          List<Map<String, dynamic>> updatedRoutes =
              List<Map<String, dynamic>>.from(await reportRepository.getRoutes(
                  month: month, ucSign: ucSign));

          routes.assignAll(updatedRoutes);
          errorMessage.value = '';
        } else {
          errorMessage.value = saveLocation['message'];
        }
      } else {
        errorMessage.value = location['message'];
      }
    } catch (e) {
      errorMessage.value = "Gagal menyimpan rute";
    } finally {
      isLoading.value = false;
    }
  }
}
