import 'package:mytrb/app/data/models/news.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/services/api_call_status.dart';
import 'package:dio/dio.dart' as dio;
import 'package:pdfx/pdfx.dart';

class NewsController extends GetxController {
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;
  var newsList = <News>[].obs;
  RxInt announcementListIndex = 0.obs;
  RxDouble scrollPosition = 0.0.obs;
  var isOpenList = List.generate(10, (_) => false.obs).obs;
  var pdfPath = Rx<Future<PdfDocument>?>(null);
  late PdfControllerPinch pdfPinchController;
  late PdfController pdfController;
  var pageCount = 0.obs;
  var pageFractionText = ''.obs;
  ScrollController scrollController = ScrollController();
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchNews();
    super.onInit();
  }

  void loadPdfFromAssets(String path) {
    final documentFuture = PdfDocument.openAsset(path);
    pdfPinchController = PdfControllerPinch(document: documentFuture);
    fetchPageCount(documentFuture);
    pdfPath.value = documentFuture;
  }

  Future<void> loadPdfFromUrl(String? url) async {
    if (url == null || url.isEmpty) {
      if (kDebugMode) {
        print('URL tidak tersedia');
      }
      pdfPath.value = null;
      return;
    }

    isLoading.value = true; // Set isLoading to true saat mulai mengunduh
    final link = Environment.urlPengumuman + url;

    try {
      final dio.Response response = await dio.Dio().get(link,
          options: dio.Options(responseType: dio.ResponseType.bytes));
      final Uint8List data = response.data;
      final document = PdfDocument.openData(data);
      pdfController = PdfController(document: document);
      pdfPath.value = document;
      await fetchPageCount(document);
    } catch (e) {
      if (kDebugMode) {
        print('Kesalahan saat memuat PDF: $e');
      }
      pdfPath.value = null; // Pastikan tetap set pdfPath ke null jika gagal
    } finally {
      isLoading.value = false; // Set isLoading ke false setelah selesai
    }
  }

  Future<void> fetchPageCount(Future<PdfDocument> documentFuture) async {
    final document = await documentFuture;
    pageCount.value = document.pagesCount;
  }

  void onPageChanged(int page) {
    if (page >= 1 && page <= pageCount.value) {
      pageFractionText.value =
          '$page/${pageCount.value}'; // Update teks informasi halaman
    }
  }

  Future<void> fetchNews() async {
    await BaseClient.safeApiCall(
      Environment.news,
      RequestType.get,
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        try {
          var res = response.data;
          var data = res['data'] as List<dynamic>;
          newsList.value = data.map((item) {
            return News.fromJson(item as Map<String, dynamic>);
          }).toList();
          // loadPdfFromUrl();
          apiCallStatus = ApiCallStatus.success;
          update();
        } catch (e) {
          if (kDebugMode) {
            print('Error parsing news data: $e');
          }
          apiCallStatus = ApiCallStatus.error;
          update();
        }
      },
      onError: (error) {
        String errorMessage = error.message;
        showErrorSnackbar(errorMessage);
        update();
      },
    );
  }

  void showErrorSnackbar(value) {
    Get.snackbar(
      "Mohon maaf",
      "$value",
      icon: const Icon(
        Icons.close,
        color: Colors.white,
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.redAccent[400],
      borderRadius: 20,
      margin: const EdgeInsets.all(15),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  void clearDialog() {
    // Reset semua pilihan dropdown
    pageFractionText.value = '';
    pageCount.value = 0;
    // pdfPinchController.dispose();
  }

  // @override
  // void dispose() {
  //   pdfPinchController.dispose(); // Tutup PDF controller dengan benar
  //   super.dispose();
  // }
}
