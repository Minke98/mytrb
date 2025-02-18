import 'package:mytrb/app/services/api_call_status.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:mytrb/config/storage/storage.dart';
import 'package:mytrb/utils/connection.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;

  @override
  void onInit() async {
    super.onInit();
    await Future.delayed(const Duration(seconds: 3));
    await checkInternetAndUserStatus();
  }

  Future<void> checkInternetAndUserStatus() async {
    bool isConnected = await ConnectionUtils.checkInternetConnection();
    if (!isConnected) {
      ConnectionUtils.showNoInternetDialog(
          'Please check your internet connection and try again.');
    } else {
      await checkUserLoggedIn();
    }
  }

  Future<void> checkUserLoggedIn() async {
    final storage = await SharedPreferences.getInstance();
    String? userInfo = storage.getString(StorageConfig.userInfo);

    if (userInfo != null && userInfo.isNotEmpty) {
      Get.offAndToNamed(Routes.INDEX);
    } else {
      Get.offAndToNamed(Routes.LOGIN);
    }
  }

  Future<void> statusApps(Map<String, dynamic> payload) async {
    bool isConnected = await ConnectionUtils.checkInternetConnection();
    if (!isConnected) {
      ConnectionUtils.showNoInternetDialog(
          'Please check your internet connection and try again.');
    } else {
      EasyLoading.show(status: 'Please wait...');
      await BaseClient.safeApiCall(
        Environment.updateBiodata,
        RequestType.post,
        data: payload,
        isJson: false,
        onLoading: () {
          apiCallStatus = ApiCallStatus.loading;
          update();
        },
        onSuccess: (response) async {
          EasyLoading.dismiss();
          var res = response.data;
          var data = res['data'];
          if (data != null && data['status'] == '1') {
            Get.toNamed(Routes.MAINTENANCE);
          } else {
            checkUserLoggedIn();
          }
        },
        onError: (error) {
          EasyLoading.dismiss();
          BaseClient.handleApiError(error);
          apiCallStatus = ApiCallStatus.error;
          update();
        },
      );
    }
  }
}
