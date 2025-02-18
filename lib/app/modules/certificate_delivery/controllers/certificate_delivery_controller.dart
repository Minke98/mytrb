import 'package:mytrb/app/data/models/certificate_delivery.dart';
import 'package:mytrb/app/data/models/certificate_detail.dart';
import 'package:mytrb/app/data/models/certificate_type.dart';
import 'package:mytrb/app/data/models/data_certificate.dart';
import 'package:mytrb/app/data/models/pengirim.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/services/api_call_status.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class CertificateDeliveryController extends GetxController {
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;
  final TextEditingController penerimaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noTeleponController = TextEditingController();
  final IndexController indexController = Get.put(IndexController());
  var pengirimansList = <CertificateDelivery>[].obs;
  var selectedFileName = ''.obs;
  var selectedFile = Rx<PlatformFile?>(null);
  var certificateTypes = <CertificateType>[].obs;
  var daftarSertifikatList = <DataCertificate>[].obs;
  List<RxBool> isCheckedList = [];
  var pengirim = Rxn<Pengirim>();
  var detailCert = Rxn<CertificateDetail>();

  @override
  void onInit() {
    super.onInit();
    fetchCertificate();
  }

  Future<void> updateStatus(String? ucPengajuan) async {
    EasyLoading.show(status: 'Please wait...');
    await BaseClient.safeApiCall(
      Environment.updateStatusCert,
      RequestType.post,
      data: {
        'uc_pengajuan': ucPengajuan,
      },
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        EasyLoading.dismiss();
        Get.close(2);
        fetchCertificate();
        update();
      },
      onError: (error) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print('Error occurred while fetching certificate details: $error');
        }
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  Future<void> fetchCertDetail(String? ucPengajuan) async {
    EasyLoading.show(status: 'Please wait...');
    await BaseClient.safeApiCall(
      Environment.getDetailCert,
      RequestType.get,
      queryParameters: {
        'uc_pengajuan': ucPengajuan,
      },
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        EasyLoading.dismiss();
        var res = response.data;

        // Proses data pengajuan jika ada
        if (res != null && res['data_pengajuan'] != null) {
          var dataPengajuan = res['data_pengajuan'];
          detailCert.value = CertificateDetail.fromJson(dataPengajuan);
        }
        if (res != null && res['data_sertifikat'] != null) {
          var dataSertifikat = res['data_sertifikat'] as List;
          daftarSertifikatList.value = dataSertifikat.map((item) {
            return DataCertificate.fromJson(item as Map<String, dynamic>);
          }).toList();
        }
        if (res != null &&
            (res['data_pengajuan'] != null || res['data_sertifikat'] != null)) {
          apiCallStatus = ApiCallStatus.success;
        } else {
          if (kDebugMode) {
            print('Data pengajuan and data sertifikat are null');
          }
          apiCallStatus = ApiCallStatus.error;
        }

        update();
      },
      onError: (error) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print('Error occurred while fetching certificate details: $error');
        }
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  Future<void> fetchCertificateTypes() async {
    EasyLoading.show(status: 'Please wait...');
    await BaseClient.safeApiCall(
      Environment.getListCert,
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
        certificateTypes.value = data.map((item) {
          return CertificateType.fromJson(item as Map<String, dynamic>);
        }).toList();
        isCheckedList = List<RxBool>.generate(
            certificateTypes.length, (index) => false.obs);
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

  Future<void> fetchFormCert() async {
    EasyLoading.show(status: 'Please wait...');
    await BaseClient.safeApiCall(
      Environment.getFormCert,
      RequestType.get,
      queryParameters: {
        'uc_pendaftar': indexController.currentUser.value!.usrUc!,
      },
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        EasyLoading.dismiss();
        var res = response.data;
        var data = res['data'];
        pengirim.value = Pengirim.fromJson(data);
        penerimaController.text = pengirim.value?.namaPengirim ?? '-';
        alamatController.text = pengirim.value?.alamatRumah ?? '-';
        noTeleponController.text = pengirim.value?.noTlpn ?? '-';
        if (kDebugMode) {
          print('Nama Pengirim: ${pengirim.value?.namaPengirim}');
        }
        if (kDebugMode) {
          print('Alamat Rumah: ${pengirim.value?.alamatRumah}');
        }
        if (kDebugMode) {
          print('No Telepon: ${pengirim.value?.noTlpn}');
        }

        apiCallStatus = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print('Error occurred while fetching form certificate: $error');
        }
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  void fetchCertificate() async {
    EasyLoading.show(status: 'Please wait...');
    await BaseClient.safeApiCall(
      Environment.getListCertificate,
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
        pengirimansList.value = data.map((item) {
          return CertificateDelivery.fromJson(item as Map<String, dynamic>);
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

  void pengajuanCert() async {
    EasyLoading.show(status: 'Please wait...');
    var selectedUcPendaftaran = [];
    for (int i = 0; i < certificateTypes.length; i++) {
      if (isCheckedList[i].value) {
        selectedUcPendaftaran.add(certificateTypes[i].ucPendaftaran!);
      }
    }

    if (selectedUcPendaftaran.isEmpty) {
      EasyLoading.showError('Tidak ada sertifikat yang dipilih');
      return;
    }

    await BaseClient.safeApiCall(
      Environment.pengajuanCert,
      RequestType.post,
      data: {
        'uc_pendaftar': indexController.currentUser.value!.usrUc!,
        'uc_pendaftaran': selectedUcPendaftaran.join(','),
      },
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        EasyLoading.dismiss();
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
        fetchCertificate();
        Get.close(1);
      },
      onError: (error) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print('Error occurred while fetching certificate list: $error');
        }
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
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
}
