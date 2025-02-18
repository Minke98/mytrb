import 'dart:convert';
import 'package:mytrb/app/data/models/data_persyaratan_diklat.dart';
import 'package:mytrb/app/data/models/info_diklat.dart';
import 'package:mytrb/app/data/models/pendaftaran_diklat.dart';
import 'package:mytrb/app/data/models/upload_file.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/services/api_call_status.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:mytrb/config/storage/storage.dart';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class UploadRequirementsController extends GetxController {
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;
  final IndexController indexController = Get.put(IndexController());
  var pendaftaranDiklatList = <PendaftaranDiklat>[].obs;
  var dataPersyaratanList = <DataPersyaratan>[].obs;
  var dataPersyaratan = <DataPersyaratan>[].obs;
  var infoDiklat = Rxn<InfoDiklat>();
  var selectedFileName = ''.obs;
  var selectedFile = Rx<PlatformFile?>(null);
  var infoUpload = Rxn<InfoDiklat>();
  var upload = Rxn<UploadFile>();
  RxInt selectedRequirementIndex = RxInt(-1);
  final RxInt pageCount = RxInt(0);
  final RxString pageFractionText = RxString('');
  ScrollController scrollController = ScrollController();
  final Rx<Future<PdfDocument>?> pdfPath = Rx<Future<PdfDocument>?>(null);
  late PdfControllerPinch pdfPinchController;

  @override
  void onInit() {
    super.onInit();
    fetchUploadPersyaratan();
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

  // Future<void> loadPdfFromUrl(String pdf) async {
  //   String url = pdf;
  //   final dio.Response response = await dio.Dio()
  //       .get(url, options: dio.Options(responseType: dio.ResponseType.bytes));
  //   final Uint8List data = response.data;
  //   final document = PdfDocument.openData(data);
  //   pdfPinchController = PdfControllerPinch(document: document);
  //   pdfPath.value = document;
  //   fetchPageCount(Future.value(document));
  // }

  Future<void> fetchPageCount(Future<PdfDocument> documentFuture) async {
    final document = await documentFuture;
    pageCount.value = document.pagesCount;
  }

  void onPageChanged(int page) {
    pageFractionText.value = '$page/${pageCount.value}';
  }

  void selectRequirement(int index) {
    selectedRequirementIndex.value = index;
  }

  Future<void> fetchUpload() async {
    EasyLoading.show(status: 'Please wait...');
    final storage = await SharedPreferences.getInstance();
    String? infoDiklatString = storage.getString(StorageConfig.infoDiklat);
    String? dataPersyaratanListString =
        storage.getString(StorageConfig.dataPersyaratanList);

    if (infoDiklatString != null && infoDiklatString.isNotEmpty) {
      var infoDiklatMap = jsonDecode(infoDiklatString);
      infoUpload.value = InfoDiklat.fromJson(infoDiklatMap);

      if (kDebugMode) {
        print('Info Upload: ${infoUpload.value?.toJson()}');
      }
    } else {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print('InfoDiklat is null or empty.');
      }
      return;
    }

    if (dataPersyaratanListString != null &&
        dataPersyaratanListString.isNotEmpty) {
      List<dynamic> dataList = jsonDecode(dataPersyaratanListString);
      dataPersyaratanList.value = dataList.map((item) {
        return DataPersyaratan.fromJson(item as Map<String, dynamic>);
      }).toList();

      if (kDebugMode) {
        print(
            'Data Persyaratan List: ${dataPersyaratanList.map((e) => e.toJson()).toList()}');
      }

      int selectedIndex = selectedRequirementIndex.value;
      if (selectedIndex >= 0 && selectedIndex < dataPersyaratanList.length) {
        var selectedRequirement = dataPersyaratanList[selectedIndex];
        if (kDebugMode) {
          print('Selected Requirement: ${selectedRequirement.toJson()}');
        }

        await BaseClient.safeApiCall(
          Environment.getFormPersyaratan,
          RequestType.get,
          queryParameters: {
            'uc_diklat': infoUpload.value?.ucDiklat ?? '',
            'uc_pendaftar': infoUpload.value?.ucPendaftar ?? '',
            'uc_pendaftaran': infoUpload.value?.ucPendaftaran ?? '',
            'uc_persyaratan': selectedRequirement.ucPersyaratan ?? '',
            'uc_diklat_persyaratan': selectedRequirement.uc ?? '',
            'uc_diklat_jadwal': infoUpload.value?.ucJadwalDiklat ?? '',
          },
          onLoading: () {
            apiCallStatus = ApiCallStatus.loading;
            update();
          },
          onSuccess: (response) async {
            EasyLoading.dismiss();
            apiCallStatus = ApiCallStatus.success;
            var res = response.data;

            if (res != null) {
              upload.value = UploadFile.fromJson(res);

              if (kDebugMode) {
                print('UploadFile Object: ${upload.toJson()}');
              }
              if (upload.value?.dataPersyaratanFile?.file?.isEmpty ?? true) {
                if (kDebugMode) {
                  print('Data Persyaratan File is empty or null.');
                }
              }
              String uploadJson = jsonEncode(upload.value?.toJson());
              await storage.setString(StorageConfig.uploadFile, uploadJson);
              if (kDebugMode) {
                print('UploadFile saved to SharedPreferences.');
              }
              update();
            } else {
              if (kDebugMode) {
                print('Response data is null.');
              }
            }
          },
          onError: (error) {
            EasyLoading.dismiss();
            if (kDebugMode) {
              print('Error occurred while uploading file: $error');
            }
            BaseClient.handleApiError(error);
            apiCallStatus = ApiCallStatus.error;
            update();
          },
        );
      } else {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              'Invalid selected index: $selectedIndex. Cannot proceed with API call.');
        }
      }
    } else {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print('Data Persyaratan List is null or empty.');
      }
    }
  }

  // tolong save hasil respons di shared di storageConfig

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

  Future<void> uploadFile() async {
    EasyLoading.show(status: 'Please wait...');
    final storage = await SharedPreferences.getInstance();
    String? infoDiklatString = storage.getString(StorageConfig.infoDiklat);
    String? dataPersyaratanListString =
        storage.getString(StorageConfig.dataPersyaratanList);

    if (infoDiklatString != null && infoDiklatString.isNotEmpty) {
      var infoDiklatMap = jsonDecode(infoDiklatString);
      infoUpload.value = InfoDiklat.fromJson(infoDiklatMap);

      if (kDebugMode) {
        print('Info Upload: ${infoUpload.value?.toJson()}');
      }
    } else {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print('InfoDiklat is null or empty.');
      }
      return;
    }

    if (selectedFile.value == null) {
      if (kDebugMode) {
        print("No file selected.");
      }
      return;
    }
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

    if (dataPersyaratanListString != null &&
        dataPersyaratanListString.isNotEmpty) {
      List<dynamic> dataList = jsonDecode(dataPersyaratanListString);
      dataPersyaratanList.value = dataList.map((item) {
        return DataPersyaratan.fromJson(item as Map<String, dynamic>);
      }).toList();

      if (kDebugMode) {
        print(
            'Data Persyaratan List: ${dataPersyaratanList.map((e) => e.toJson()).toList()}');
      }

      int selectedIndex = selectedRequirementIndex.value;
      if (selectedIndex >= 0 && selectedIndex < dataPersyaratanList.length) {
        var selectedRequirement = dataPersyaratanList[selectedIndex];
        if (kDebugMode) {
          print('Selected Requirement: ${selectedRequirement.toJson()}');
        }

        await BaseClient.safeApiCall(
          Environment.uploadsDoc,
          RequestType.post,
          data: {
            'uc_diklat': infoUpload.value?.ucDiklat ?? '',
            'uc_pendaftar': infoUpload.value?.ucPendaftar ?? '',
            'uc_pendaftaran': infoUpload.value?.ucPendaftaran ?? '',
            'uc_persyaratan': selectedRequirement.ucPersyaratan ?? '',
            'uc_diklat_persyaratan': selectedRequirement.uc ?? '',
            'uc_diklat_jadwal': infoUpload.value?.ucJadwalDiklat ?? '',
            'status_file': '0',
            'file': await dio.MultipartFile.fromFile(file.path,
                filename: file.path.split('/').last),
            'nik': indexController.currentUser.value?.usrNik,
          }, // Ganti data dengan formData
          isJson: false,
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
          onLoading: () {
            apiCallStatus = ApiCallStatus.loading;
            update();
          },
          onSuccess: (response) async {
            EasyLoading.dismiss();
            apiCallStatus = ApiCallStatus.success;
            var res = response.data;
            String message = res['message'] ?? 'Success';
            selectedFileName.value = '';
            Get.snackbar(
              'Upload Berhasil', // Title
              message, // Body
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              borderRadius: 20,
              margin: const EdgeInsets.all(15),
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
              isDismissible: true,
              dismissDirection: DismissDirection.horizontal,
              forwardAnimationCurve: Curves.easeOutBack,
            );
            fetchListPersyaratan(infoUpload.value!.ucPendaftaran!);
            Get.close(1);
          },

          onError: (error) {
            EasyLoading.dismiss();
            BaseClient.handleApiError(error);
            apiCallStatus = ApiCallStatus.error;
            update();
          },
        );
      } else {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              'Invalid selected index: $selectedIndex. Cannot proceed with API call.');
        }
      }
    } else {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print('Data Persyaratan List is null or empty.');
      }
    }
  }

  Future<void> saveFile() async {
    EasyLoading.show(status: 'Please wait...');
    final storage = await SharedPreferences.getInstance();
    String? infoDiklatString = storage.getString(StorageConfig.infoDiklat);
    String? dataPersyaratanListString =
        storage.getString(StorageConfig.dataPersyaratanList);
    String? dataPersyaratanFile = storage.getString(StorageConfig.uploadFile);

    if (infoDiklatString != null && infoDiklatString.isNotEmpty) {
      var infoDiklatMap = jsonDecode(infoDiklatString);
      infoUpload.value = InfoDiklat.fromJson(infoDiklatMap);

      if (kDebugMode) {
        print('Info Upload: ${infoUpload.value?.toJson()}');
      }
    } else {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print('InfoDiklat is null or empty.');
      }
      return;
    }
    if (dataPersyaratanFile != null && dataPersyaratanFile.isNotEmpty) {
      var dataPersyaratanFileMap = jsonDecode(dataPersyaratanFile);
      upload.value = UploadFile.fromJson(dataPersyaratanFileMap);

      if (kDebugMode) {
        print('Info Upload: ${infoUpload.value?.toJson()}');
      }
    } else {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print('InfoDiklat is null or empty.');
      }
      return;
    }

    if (dataPersyaratanListString != null &&
        dataPersyaratanListString.isNotEmpty) {
      List<dynamic> dataList = jsonDecode(dataPersyaratanListString);
      dataPersyaratanList.value = dataList.map((item) {
        return DataPersyaratan.fromJson(item as Map<String, dynamic>);
      }).toList();

      if (kDebugMode) {
        print(
            'Data Persyaratan List: ${dataPersyaratanList.map((e) => e.toJson()).toList()}');
      }

      int selectedIndex = selectedRequirementIndex.value;
      if (selectedIndex >= 0 && selectedIndex < dataPersyaratanList.length) {
        var selectedRequirement = dataPersyaratanList[selectedIndex];
        if (kDebugMode) {
          print('Selected Requirement: ${selectedRequirement.toJson()}');
        }

        await BaseClient.safeApiCall(
          Environment.uploadsDoc,
          RequestType.post,
          data: {
            'uc_diklat': infoUpload.value?.ucDiklat ?? '',
            'uc_pendaftar': infoUpload.value?.ucPendaftar ?? '',
            'uc_pendaftaran': infoUpload.value?.ucPendaftaran ?? '',
            'uc_persyaratan': selectedRequirement.ucPersyaratan ?? '',
            'uc_diklat_persyaratan': selectedRequirement.uc ?? '',
            'uc_diklat_jadwal': infoUpload.value?.ucJadwalDiklat ?? '',
            'status_file': upload.value?.statusFile ?? '',
            'file_ready': upload.value?.dataPersyaratanFile?.file ?? '',
            'nik': indexController.currentUser.value?.usrNik,
          }, // Ganti data dengan formData
          isJson: false,
          onLoading: () {
            apiCallStatus = ApiCallStatus.loading;
            update();
          },
          onSuccess: (response) async {
            EasyLoading.dismiss();
            apiCallStatus = ApiCallStatus.success;
            var res = response.data;
            String message = res['message'] ?? 'Success';
            selectedFileName.value = '';
            Get.snackbar(
              'Berhasil', // Title
              message, // Body
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              borderRadius: 20,
              margin: const EdgeInsets.all(15),
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
              isDismissible: true,
              dismissDirection: DismissDirection.horizontal,
              forwardAnimationCurve: Curves.easeOutBack,
            );
            fetchListPersyaratan(infoUpload.value!.ucPendaftaran!);
            Get.close(1);
          },

          onError: (error) {
            EasyLoading.dismiss();
            String errorMessage = error.message;
            update();
            Get.snackbar(
              'Mohon maaf',
              errorMessage,
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
          },
        );
      } else {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              'Invalid selected index: $selectedIndex. Cannot proceed with API call.');
        }
      }
    } else {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print('Data Persyaratan List is null or empty.');
      }
    }
  }

  Future<void> updateFile() async {
    EasyLoading.show(status: 'Please wait...');
    final storage = await SharedPreferences.getInstance();
    String? infoDiklatString = storage.getString(StorageConfig.infoDiklat);
    String? dataPersyaratanListString =
        storage.getString(StorageConfig.dataPersyaratanList);
    String? dataPersyaratanFile = storage.getString(StorageConfig.uploadFile);

    if (infoDiklatString != null && infoDiklatString.isNotEmpty) {
      var infoDiklatMap = jsonDecode(infoDiklatString);
      infoUpload.value = InfoDiklat.fromJson(infoDiklatMap);

      if (kDebugMode) {
        print('Info Upload: ${infoUpload.value?.toJson()}');
      }
    } else {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print('InfoDiklat is null or empty.');
      }
      return;
    }

    if (dataPersyaratanFile != null && dataPersyaratanFile.isNotEmpty) {
      var dataPersyaratanFileMap = jsonDecode(dataPersyaratanFile);
      upload.value = UploadFile.fromJson(dataPersyaratanFileMap);

      if (kDebugMode) {
        print('Info Upload: ${infoUpload.value?.toJson()}');
      }
    } else {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print('InfoDiklat is null or empty.');
      }
      return;
    }

    if (selectedFile.value == null) {
      if (kDebugMode) {
        print("No file selected.");
      }
      return;
    }
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
    if (dataPersyaratanListString != null &&
        dataPersyaratanListString.isNotEmpty) {
      List<dynamic> dataList = jsonDecode(dataPersyaratanListString);
      dataPersyaratanList.value = dataList.map((item) {
        return DataPersyaratan.fromJson(item as Map<String, dynamic>);
      }).toList();

      if (kDebugMode) {
        print(
            'Data Persyaratan List: ${dataPersyaratanList.map((e) => e.toJson()).toList()}');
      }

      int selectedIndex = selectedRequirementIndex.value;
      if (selectedIndex >= 0 && selectedIndex < dataPersyaratanList.length) {
        var selectedRequirement = dataPersyaratanList[selectedIndex];
        if (kDebugMode) {
          print('Selected Requirement: ${selectedRequirement.toJson()}');
        }

        await BaseClient.safeApiCall(
          Environment.updateDoc,
          RequestType.post,
          data: {
            'uc_file_persyaratan': upload.value?.dataPersyaratanFile?.uc ?? '',
            'uc_persyaratan': selectedRequirement.ucPersyaratan ?? '',
            'uc_pendaftar': infoUpload.value?.ucPendaftar ?? '',
            'file': await dio.MultipartFile.fromFile(file.path,
                filename: file.path.split('/').last),
            'nik': indexController.currentUser.value?.usrNik,
          }, // Ganti data dengan formData
          isJson: false,
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
          onLoading: () {
            apiCallStatus = ApiCallStatus.loading;
            update();
          },
          onSuccess: (response) async {
            EasyLoading.dismiss();
            apiCallStatus = ApiCallStatus.success;
            var res = response.data;
            String message = res['message'] ?? 'Success';
            selectedFileName.value = '';
            Get.snackbar(
              'Update Berhasil', // Title
              message, // Body
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              borderRadius: 20,
              margin: const EdgeInsets.all(15),
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
              isDismissible: true,
              dismissDirection: DismissDirection.horizontal,
              forwardAnimationCurve: Curves.easeOutBack,
            );
            fetchListPersyaratan(infoUpload.value!.ucPendaftaran!);
            Get.close(1);
          },

          onError: (error) {
            EasyLoading.dismiss();
            BaseClient.handleApiError(error);
            apiCallStatus = ApiCallStatus.error;
            update();
          },
        );
      } else {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print(
              'Invalid selected index: $selectedIndex. Cannot proceed with API call.');
        }
      }
    } else {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print('Data Persyaratan List is null or empty.');
      }
    }
  }

  Future<void> sendPersyaratan() async {
    EasyLoading.show(status: 'Please wait...');
    final storage = await SharedPreferences.getInstance();
    String? infoDiklatString = storage.getString(StorageConfig.infoDiklat);
    if (infoDiklatString != null && infoDiklatString.isNotEmpty) {
      var infoDiklatMap = jsonDecode(infoDiklatString);
      infoUpload.value = InfoDiklat.fromJson(infoDiklatMap);

      if (kDebugMode) {
        print('Info Upload: ${infoUpload.value?.toJson()}');
      }
    } else {
      EasyLoading.dismiss();
      if (kDebugMode) {
        print('InfoDiklat is null or empty.');
      }
      return;
    }

    await BaseClient.safeApiCall(
      Environment.sendDoc,
      RequestType.post,
      data: {
        'uc_diklat': infoUpload.value?.ucDiklat ?? '',
        'uc_pendaftar': infoUpload.value?.ucPendaftar ?? '',
        'uc_pendaftaran': infoUpload.value?.ucPendaftaran ?? '',
        'uc_diklat_jadwal': infoUpload.value?.ucJadwalDiklat ?? '',
      },
      isJson: false,
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        EasyLoading.dismiss();
        apiCallStatus = ApiCallStatus.success;
        var res = response.data;
        String message = res['message'] ?? 'Success';
        Get.back();
        fetchUploadPersyaratan();
        Get.snackbar(
          'Persyaratan terkirim', // Title
          message, // Body dari respons sukses
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
      },
      onError: (error) {
        EasyLoading.dismiss();
        String errorMessage = error.message;
        update();
        Get.snackbar(
          'Mohon maaf',
          errorMessage,
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
      },
    );
  }

  void fetchUploadPersyaratan() async {
    await BaseClient.safeApiCall(
      Environment.uploadPersyaratan,
      RequestType.get,
      queryParameters: {
        'uc_pendaftar': indexController.currentUser.value!.usrUc!
      },
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        var res = response.data;
        var data = res['data'] as List<dynamic>;
        pendaftaranDiklatList.value = data.map((item) {
          return PendaftaranDiklat.fromJson(item as Map<String, dynamic>);
        }).toList();
        apiCallStatus = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        if (kDebugMode) {
          print('Error occurred while fetching kategori list: $error');
        }
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  void fetchListPersyaratan(String ucPendaftaran) async {
    await BaseClient.safeApiCall(
      Environment.dataPersyaratan,
      RequestType.get,
      queryParameters: {'uc_pendaftaran': ucPendaftaran},
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        try {
          var res = response.data;
          if (res is Map) {
            final storage = await SharedPreferences.getInstance();

            if (res['info_diklat'] != null) {
              infoDiklat.value = InfoDiklat.fromJson(res['info_diklat']);
              await storage.setString(
                  StorageConfig.infoDiklat, jsonEncode(infoDiklat.toJson()));
            }

            if (res['data_persyaratan'] is List) {
              dataPersyaratanList.value =
                  (res['data_persyaratan'] as List).map((item) {
                return DataPersyaratan.fromJson(item as Map<String, dynamic>);
              }).toList();
              await storage.setString(
                  StorageConfig.dataPersyaratanList,
                  jsonEncode(
                      dataPersyaratanList.map((e) => e.toJson()).toList()));

              apiCallStatus = ApiCallStatus.success;
            } else {
              if (kDebugMode) {
                print('Format data tidak sesuai: data_persyaratan bukan List');
              }
              apiCallStatus = ApiCallStatus.error;
            }
          }

          update();
        } catch (e) {
          if (kDebugMode) {
            print('Terjadi kesalahan saat mem-parsing data: $e');
          }
          apiCallStatus = ApiCallStatus.error;
          update();
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('Terjadi kesalahan saat mengambil data: $error');
        }
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }
}
