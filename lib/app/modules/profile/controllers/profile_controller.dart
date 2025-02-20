import 'dart:io';
import 'package:get/get.dart';
import 'package:mytrb/app/Repository/profile_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final ProfileRepository profileRepository;

  var isLoading = false.obs;
  var userData = {}.obs;
  var errorMessage = ''.obs;

  ProfileController({required this.profileRepository});

  @override
  void onInit() {
    super.onInit();
    getCurrentProfile();
  }

  Future<void> getCurrentProfile() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? uc = prefs.getString('userUc');
    if (uc == null) {
      errorMessage.value = "Profile Tidak Dapat Ditemukan";
    } else {
      userData.value = await UserRepository.getLocalUser(uc: uc);
    }
    isLoading.value = false;
  }

  Future<void> updateProfile({
    required String email,
    File? foto,
    required String password,
    required String newpassword,
  }) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? uc = prefs.getString('userUc');
    if (uc == null) {
      errorMessage.value = "Profile Tidak Dapat Ditemukan";
    } else {
      Map res = await profileRepository.updateUser(
        email: email,
        foto: foto,
        password: password,
        newpassword: newpassword,
      );
      if (res['status'] == true) {
        userData.value = await UserRepository.getLocalUser(uc: uc);
      } else {
        errorMessage.value = res['message'];
      }
    }
    isLoading.value = false;
  }
}
