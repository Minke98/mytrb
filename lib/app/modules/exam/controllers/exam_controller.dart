import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mytrb/app/Repository/exam_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:mytrb/utils/auth_biometric.dart';
import 'package:mytrb/utils/connection.dart';
import 'package:mytrb/utils/get_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExamController extends GetxController {
  final UserRepository userRepository;
  final ExamRepository examRepository;
  final Logger _logger = Logger();
  var exams = [].obs;
  var examError = ''.obs;
  var isLoading = false.obs;
  var selectedSemester = "".obs;
  WebViewController? webViewController;

  ExamController({required this.userRepository, required this.examRepository});

  @override
  Future<void> onInit() async {
    super.onInit();
    initExam();
  }

  void setSelectedSemester(String semester) {
    selectedSemester.value = semester;
  }

  Future<void> initExam({bool background = false}) async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: "Please wait...");

      bool isConnected = await ConnectionUtils.checkInternetConnection();
      if (!isConnected) {
        ConnectionUtils().showNoInternetDialog(
          "Apologies, the syncing process requires an internet connection.",
        );
        return;
      }

      bool isFastConnection = await ConnectionUtils.isConnectionFast();
      if (!isFastConnection) {
        ConnectionUtils().showNoInternetDialog(
          "Sorry, this access requires an internet connection.",
          closeToHome: true,
        );
        return;
      }

      var deviceId = await getUniqueDeviceId();
      var isAuth = await userRepository.checkAuth(
        deviceId: deviceId,
        fromBackround: background,
      );

      final prefs = await SharedPreferences.getInstance();
      prefs.setString("userUc", isAuth['user'].uc);

      var userData = await userRepository.getUserData(uc: isAuth['user'].uc);
      if (userData != null) {
        var response = await examRepository.getExam(userData: userData['data']);
        if (response['status'] == 200) {
          final List<Map> resExam = List<Map>.from(response['data'] ?? []);
          final now = DateTime.now();
          exams.value = resExam.map((exam) {
            final openTime = DateTime.tryParse(exam['open_time'] ?? '') ?? now;
            final closeTime = DateTime.tryParse(exam['close_time'] ?? '') ??
                now.add(const Duration(days: 365));
            return {
              ...exam,
              'canBeOpened': now.isAfter(openTime) && now.isBefore(closeTime),
            };
          }).toList();
        } else {
          examError.value = "Gagal memuat ujian";
          EasyLoading.showError("Failed to load exams");
          Get.back();
        }
      } else {
        examError.value = "Data pengguna tidak ditemukan";
        EasyLoading.showError("User data not found");
      }
    } catch (e) {
      _logger.e("Error in initExam: $e");
      examError.value = "Mohon maaf, Examination harus diakses secara online.";
      EasyLoading.showError("Error: Examination must be accessed online");
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  Future<void> getUrlExam({required String uc, bool background = false}) async {
    try {
      EasyLoading.show(status: "Loading exam URL...");

      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        examError.value = "Mohon maaf, akses ini memerlukan koneksi internet.";
        EasyLoading.showError("Koneksi internet diperlukan.");
        return;
      }

      var deviceId = await getUniqueDeviceId();
      var isAuth = await userRepository.checkAuth(
        deviceId: deviceId,
        fromBackround: background,
      );

      final prefs = await SharedPreferences.getInstance();
      prefs.setString("userUc", isAuth['user'].uc);

      var userData = await userRepository.getUserData(uc: isAuth['user'].uc);
      if (userData != null) {
        var response = await examRepository.getUrlExam(userData, uc);
        if (response['status'] == 200) {
          webViewController = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onPageStarted: (String url) {},
                onPageFinished: (String url) async {
                  // **Autentikasi sebelum masuk ke halaman ujian**
                  bool isAuthenticated = await BiometricAuth.authenticateUser(
                      'Gunakan autentikasi biometrik untuk mengakses ujian');
                  if (!isAuthenticated) {
                    EasyLoading.showError('Autentikasi biometrik gagal');
                    return;
                  }

                  Get.toNamed(Routes.EXAM_WEB);
                },
                onWebResourceError: (WebResourceError error) {
                  Get.snackbar('Error', 'Terjadi kesalahan memuat halaman');
                },
                onNavigationRequest: (NavigationRequest request) {
                  if (request.url.startsWith('https://www.youtube.com/')) {
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            )
            ..loadRequest(Uri.parse(response['examUrl']));

          EasyLoading.showSuccess("Exam URL loaded successfully");
        } else {
          examError.value = "Gagal memuat ujian";
          EasyLoading.showError("Failed to load exam");
        }
      } else {
        examError.value = "Data pengguna tidak ditemukan";
        EasyLoading.showError("User data not found");
      }
    } catch (e) {
      _logger.e("Error in getUrlExam: $e");
      examError.value = "Mohon maaf, akses ini memerlukan koneksi internet.";
      EasyLoading.showError("Error: Internet connection required.");
    } finally {
      EasyLoading.dismiss();
    }
  }
}
