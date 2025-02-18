import 'dart:io';

import 'package:mytrb/app/data/models/diklat_pengaduan.dart';
import 'package:mytrb/app/data/models/pengaduan_detail.dart';
import 'package:mytrb/app/data/models/type_pengaduan.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/modules/training/controllers/training_controller.dart';
import 'package:mytrb/app/services/api_call_status.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/data/models/report_evaluation.dart';
import 'package:dio/dio.dart' as dio;
import 'package:pdfx/pdfx.dart';

class ReportEvaluationController extends GetxController {
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;
  final IndexController indexController = Get.put(IndexController());
  final TrainingController trainingController = Get.put(TrainingController());
  final TextEditingController pengaduanController = TextEditingController();
  var tickets = <ReportEvaluation>[].obs;
  var selectedFileName = ''.obs;
  var selectedFile = Rx<PlatformFile?>(null);
  final RxInt pageCount = RxInt(0);
  final RxString pageFractionText = RxString('');
  ScrollController scrollController = ScrollController();
  final Rx<Future<PdfDocument>?> pdfPath = Rx<Future<PdfDocument>?>(null);
  late PdfControllerPinch pdfPinchController;
  var reportList = <ReportEvaluation>[].obs;
  var typeReportList = <TypePengaduan>[].obs;
  var selectedDiklat = ''.obs;
  var selectedTypeReport = ''.obs;
  var diklatPengaduanList = <DiklatPengaduan>[].obs;
  var isDropdownOpened = false.obs;
  var detailPengaduan = Rxn<PengaduanDetail>();

  // Sample data to populate the tickets
  @override
  void onInit() {
    super.onInit();
    fetchReport();
  }

  void fetchReport() async {
    EasyLoading.show(status: 'Please wait...');
    await BaseClient.safeApiCall(
      Environment.getListReport,
      RequestType.get,
      queryParameters: {
        'uc_pendaftar': indexController.currentUser.value!.usrUc!
      },
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        EasyLoading.dismiss();
        var res = response.data;
        var data = res['data'] as List<dynamic>;
        reportList.value = data.map((item) {
          return ReportEvaluation.fromJson(item as Map<String, dynamic>);
        }).toList();
        apiCallStatus = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print('Error occurred while fetching kategori list: $error');
        }
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  void fetchDiklatReport() async {
    EasyLoading.show(status: 'Please wait...');
    await BaseClient.safeApiCall(
      Environment.getDiklatReport,
      RequestType.get,
      queryParameters: {
        'uc_pendaftar': indexController.currentUser.value!.usrUc!
      },
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        EasyLoading.dismiss();
        var res = response.data;
        var data = res['data'] as List<dynamic>;
        diklatPengaduanList.value = data.map((item) {
          return DiklatPengaduan.fromJson(item as Map<String, dynamic>);
        }).toList();
        apiCallStatus = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print('Error occurred while fetching kategori list: $error');
        }
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  void fetchTypeReport() async {
    EasyLoading.show(status: 'Please wait...');
    await BaseClient.safeApiCall(
      Environment.getTypeReport,
      RequestType.get,
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        EasyLoading.dismiss();
        var res = response.data;
        var data = res['data'] as List<dynamic>;
        typeReportList.value = data.map((item) {
          return TypePengaduan.fromJson(item as Map<String, dynamic>);
        }).toList();
        apiCallStatus = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print('Error occurred while fetching kategori list: $error');
        }
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  void sendReport() async {
    EasyLoading.show(status: 'Please wait...');
    dio.MultipartFile? fileUpload;
    if (selectedFile.value != null) {
      var file = File(selectedFile.value!.path!);
      final fileSize = await file.length();
      const maxSize = 2 * 1024 * 1024; // 2 MB in bytes

      if (fileSize > maxSize) {
        EasyLoading.dismiss();
        Get.snackbar(
          'Mohon maaf',
          'Ukuran file maksimal 2 MB',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
        return;
      }
      fileUpload = await dio.MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last);
    }
    await BaseClient.safeApiCall(
      Environment.sendPengaduan,
      RequestType.post,
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      data: {
        'uc_pendaftar': indexController.currentUser.value!.usrUc!,
        'uc_pendaftaran': selectedDiklat.value,
        'file': fileUpload,
        'id_pengaduan': selectedTypeReport,
        'aduan': pengaduanController.text,
      },
      onSuccess: (response) async {
        EasyLoading.dismiss();
        fetchReport();
        Get.close(1);

        apiCallStatus = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print('Error occurred while fetching kategori list: $error');
        }
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  void getDetailPengaduan(String? ucPengaduan) async {
    EasyLoading.show(status: 'Please wait...');

    await BaseClient.safeApiCall(
      Environment.getDetailPengaduan,
      RequestType.get,
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      queryParameters: {'uc_pengaduan': ucPengaduan},
      onSuccess: (response) async {
        EasyLoading.dismiss();
        var res = response.data;
        var data = res['data'];
        detailPengaduan.value = PengaduanDetail.fromJson(data);
        apiCallStatus = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print('Error occurred while fetching kategori list: $error');
        }
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  Future<void> loadPdfFromUrl(String pdfUrl) async {
    try {
      final dio.Response response = await dio.Dio().get(
        pdfUrl,
        options: dio.Options(responseType: dio.ResponseType.bytes),
      );
      final Uint8List data = response.data;
      final document = PdfDocument.openData(data);
      pdfPinchController = PdfControllerPinch(document: document);
      pdfPath.value = document;
      fetchPageCount(Future.value(document));
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat PDF: $e');
    }
  }

  Future<void> fetchPageCount(Future<PdfDocument> documentFuture) async {
    final document = await documentFuture;
    pageCount.value = document.pagesCount;
  }

  void onPageChanged(int page) {
    pageFractionText.value = '$page/${pageCount.value}';
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      selectedFileName.value = result.files.single.name;
      selectedFile.value = result.files.single;
    }
  }

  void clearDialog() {
    // Reset semua pilihan dropdown
    selectedDiklat.value = '';
    selectedTypeReport.value = '';
    pengaduanController.clear();
    selectedFileName.value = '';
  }
}
