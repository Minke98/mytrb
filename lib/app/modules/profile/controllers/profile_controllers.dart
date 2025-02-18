import 'dart:convert';
import 'dart:io';
import 'package:mytrb/app/data/models/foto_profil.dart';
import 'package:mytrb/app/data/models/login.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/config/storage/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytrb/app/services/api_call_status.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

class ProfileController extends GetxController {
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;
  final IndexController indexController = Get.put(IndexController());
  final changePassController = TextEditingController();
  final retypePassController = TextEditingController();
  final oldPassController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  var image = Rxn<File>();
  var imageUrl = "".obs;

  Future<void> loadSavedPhoto() async {
    final storage = await SharedPreferences.getInstance();
    String? savedPhotoData = storage.getString(StorageConfig.changeFoto);

    if (savedPhotoData != null) {
      UpdatePhotoProfile savedPhoto =
          UpdatePhotoProfile.fromJson(jsonDecode(savedPhotoData));
      imageUrl.value = savedPhoto.data!;
      update();
    }
  }

  Future<void> changeFoto(BuildContext context) async {
    EasyLoading.show(status: 'Please wait...');
    if (image.value != null) {
      var file = File(image.value!.path);
      await BaseClient.safeApiCall(
        Environment.changeFoto,
        RequestType.post,
        data: {
          'uc_pendaftar': indexController.currentUser.value!.usrUc!,
          'photo': await dio.MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last),
        },
        onLoading: () {
          apiCallStatus = ApiCallStatus.loading;
          update();
        },
        onSuccess: (response) async {
          EasyLoading.dismiss();
          var res = response.data;
          var updatedPhoto = res['data'];
          final storage = await SharedPreferences.getInstance();
          String? userInfo = storage.getString(StorageConfig.userInfo);
          if (userInfo != null) {
            Map<String, dynamic> userMap = jsonDecode(userInfo);
            UserLogin regUser = UserLogin.fromJson(userMap);
            regUser.usrPhoto = updatedPhoto;
            await storage.setString(
                StorageConfig.userInfo, jsonEncode(regUser.toJson()));
            indexController.loadUserInfo();
          }
          String message = res['message'] ?? 'Success';
          Get.snackbar(
            'Selamat', // Title
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

          apiCallStatus = ApiCallStatus.success;
          update();
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
  }

  Future<void> changePassword(BuildContext context) async {
    if (changePassController.text.isNotEmpty &&
        (retypePassController.text.isEmpty ||
            retypePassController.text != changePassController.text)) {
      Get.snackbar('Error', 'Password baru tidak cocok');
      return;
    }

    if (changePassController.text.isNotEmpty &&
        retypePassController.text.isNotEmpty) {
      await BaseClient.safeApiCall(
        Environment.changePassword,
        RequestType.post,
        data: {
          'uc_pendaftar': indexController.currentUser.value?.usrUc ?? '',
          'Password': changePassController.text.trim(),
        },
        onLoading: () {
          apiCallStatus = ApiCallStatus.loading;
          update();
        },
        onSuccess: (response) {
          apiCallStatus = ApiCallStatus.success;
          var res = response.data;
          String message = res['message'] ?? 'Success';
          changePassController.clear();
          retypePassController.clear();
          Get.snackbar(
            'Selamat', // Title
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
        },
        onError: (error) {
          BaseClient.handleApiError(error);
          apiCallStatus = ApiCallStatus.error;
          update();
        },
      );
    }
  }

  Future<void> getImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      image.value = File(pickedFile.path);
      update();
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
  }

  Future<void> getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File? imageFile = File(pickedFile.path);
      if (imageFile.existsSync()) {
        image.value = imageFile;
        update();
      } else {
        if (kDebugMode) {
          print('File not found: ${pickedFile.path}');
        }
      }
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
  }

  // Future<void> loadAndUpdateUserPhoto(String updatedPhoto) async {
  //   final storage = await SharedPreferences.getInstance();
  //   String? userInfo = storage.getString(StorageConfig.userInfo);
  //   if (userInfo != null) {
  //     Map<String, dynamic> userMap = jsonDecode(userInfo);
  //     UserLogin regUser = UserLogin.fromJson(userMap);
  //     regUser.usrPhoto = updatedPhoto;
  //     await storage.setString(
  //       StorageConfig.userInfo,
  //       jsonEncode(regUser.toJson()),
  //     );
  //     print("User photo updated and saved to SharedPreferences");
  //   } else {
  //     print("No user data found in SharedPreferences");
  //   }
  // }
}
