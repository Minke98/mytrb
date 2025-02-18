import 'package:mytrb/app/data/models/billing_detail.dart';
import 'package:mytrb/app/data/models/billing.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:mytrb/app/services/api_call_status.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BillingController extends GetxController {
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;
  final IndexController indexController = Get.put(IndexController());
  WebViewController? webViewController;
  var billingList = <Billing>[].obs;
  var billingDetail = Rxn<BillingDetail>();
  @override
  void onInit() {
    super.onInit();
    fetchBilling();
  }

  Future<void> fetchWebViewInvoice(String? linkCetakInvoice) async {
    EasyLoading.show(status: 'Please wait...');
    if (linkCetakInvoice == null || linkCetakInvoice.isEmpty) {
      Get.snackbar('Error', 'Link cetak invoice tidak tersedia');
      return;
    }
    try {
      webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {},
            onPageStarted: (String url) {},
            onPageFinished: (String url) {
              EasyLoading.dismiss();
              Get.toNamed(Routes.BILLING_WEB_VIEW);
            },
            onWebResourceError: (WebResourceError error) {
              EasyLoading.dismiss();
              Get.snackbar('Error', 'Terjadi kesalahan memuat halaman');
            },
            onNavigationRequest: (NavigationRequest request) {
              EasyLoading.dismiss();
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(linkCetakInvoice));
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar('Error', 'Gagal memuat halaman: $e');
    }
  }

  Future<void> fetchWebViewCard(String? linkCetakKartu) async {
    EasyLoading.show(status: 'Please wait...');
    if (linkCetakKartu == null || linkCetakKartu.isEmpty) {
      Get.snackbar('Error', 'Link cetak kartu tidak tersedia');
      return;
    }
    try {
      webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {},
            onPageStarted: (String url) {},
            onPageFinished: (String url) {
              EasyLoading.dismiss();
              Get.toNamed(Routes.BILLING_CARD_WEB_VIEW);
            },
            onWebResourceError: (WebResourceError error) {
              EasyLoading.dismiss();
              Get.snackbar('Error', 'Terjadi kesalahan memuat halaman');
            },
            onNavigationRequest: (NavigationRequest request) {
              EasyLoading.dismiss();
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(linkCetakKartu));
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar('Error', 'Gagal memuat halaman: $e');
    }
  }

  Future<void> fetchWebViewPaymentMethod(String? linkCaraPembayaran) async {
    EasyLoading.show(status: 'Please wait...');
    if (linkCaraPembayaran == null || linkCaraPembayaran.isEmpty) {
      Get.snackbar('Error', 'Link cetak kartu tidak tersedia');
      return;
    }
    try {
      webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {},
            onPageStarted: (String url) {},
            onPageFinished: (String url) {
              EasyLoading.dismiss();
              Get.toNamed(Routes.BILLING_CARD_WEB_VIEW);
            },
            onWebResourceError: (WebResourceError error) {
              EasyLoading.dismiss();
              Get.snackbar('Error', 'Terjadi kesalahan memuat halaman');
            },
            onNavigationRequest: (NavigationRequest request) {
              EasyLoading.dismiss();
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(linkCaraPembayaran));
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar('Error', 'Gagal memuat halaman: $e');
    }
  }

  void fetchBilling() async {
    EasyLoading.show(status: 'Please wait...');
    await BaseClient.safeApiCall(
      Environment.billing,
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
        billingList.value = data.map((item) {
          return Billing.fromJson(item as Map<String, dynamic>);
        }).toList();
        apiCallStatus = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        EasyLoading.dismiss();
        String errorMessage = error.message;
        showErrorSnackbar(errorMessage);
        update();
      },
    );
  }

  Future<void> fetchBillingDetail(String? ucPendaftaran) async {
    EasyLoading.show(status: 'Please wait...');
    await BaseClient.safeApiCall(
      Environment.billingDetail,
      RequestType.get,
      queryParameters: {'uc_pendaftaran': ucPendaftaran},
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
      },
      onSuccess: (response) async {
        EasyLoading.dismiss();
        var res = response.data;
        var data = res['data'];
        billingDetail.value = BillingDetail.fromJson(data);
        apiCallStatus = ApiCallStatus.success;
      },
      onError: (error) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print('Error occurred while fetching diklat data: $error');
        }
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
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
}
