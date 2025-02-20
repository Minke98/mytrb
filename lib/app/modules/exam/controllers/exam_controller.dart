import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mytrb/app/Repository/exam_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExamController extends GetxController {
  final UserRepository userRepository;
  final ExamRepository examRepository;
  final Logger _logger = Logger();

  var exams = [].obs;
  var examError = ''.obs;
  var isLoading = false.obs;
  WebViewController? webViewController;

  ExamController({required this.userRepository, required this.examRepository});

  Future<void> initExam(String deviceId, bool background) async {
    try {
      isLoading.value = true;
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        examError.value = "Mohon maaf, akses ini memerlukan koneksi internet.";
        return;
      }

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
          final currentTime = DateTime.now();
          exams.value = resExam.map((exam) {
            final openTime = exam['open_time'] != null
                ? DateTime.parse(exam['open_time'])
                : DateTime.now();
            final closeTime = exam['close_time'] != null
                ? DateTime.parse(exam['close_time'])
                : DateTime.now().add(const Duration(days: 365));
            final canBeOpened = (currentTime.isAfter(openTime)) &&
                (currentTime.isBefore(closeTime));
            return {
              ...exam,
              'canBeOpened': canBeOpened,
            };
          }).toList();
        } else {
          examError.value = "Gagal memuat ujian";
        }
      } else {
        examError.value = "Data pengguna tidak ditemukan";
      }
    } catch (e) {
      _logger.e("Error in initExam: $e");
      examError.value = "Mohon maaf, Examination harus diakses secara online.";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUrlExam(String deviceId, bool background, String uc) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        examError.value = "Mohon maaf, akses ini memerlukan koneksi internet.";
        return;
      }
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
                onProgress: (int progress) {
                  debugPrint('WebView is loading (progress: $progress%)');
                },
                onPageStarted: (String url) {
                  debugPrint('Page started loading: $url');
                },
                onPageFinished: (String url) {
                  debugPrint('Page finished loading: $url');
                },
                onWebResourceError: (WebResourceError error) {
                  debugPrint('WebView error: ${error.description}');
                },
                onNavigationRequest: (NavigationRequest request) {
                  if (request.url.startsWith('https://www.youtube.com/')) {
                    debugPrint('Blocking navigation to ${request.url}');
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            )
            ..loadRequest(Uri.parse(response['examUrl']));
        } else {
          examError.value = "Gagal memuat ujian";
        }
      } else {
        examError.value = "Data pengguna tidak ditemukan";
      }
    } catch (e) {
      _logger.e("Error in getUrlExam: $e");
      examError.value = "Mohon maaf, akses ini memerlukan koneksi internet.";
    }
  }
}
