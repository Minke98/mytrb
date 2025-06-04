import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mytrb/app/Repository/profile_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:mytrb/utils/manual_con_check.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final ProfileRepository profileRepository;
  ProfileController({required this.profileRepository});

  var isLoading = false.obs;
  var userData = {}.obs;
  var errorMessage = ''.obs;
  var isEditing = false.obs;
  var passwordVisible = false.obs;
  var newPasswordVisible = false.obs;
  var retypePasswordVisible = false.obs;
  var activeFotoProfile = "assets/images/profile.jpg".obs;
  var fotoProfile = Rx<XFile?>(null);
  TextStyle? formTextStyle;
  var image = Rx<File?>(null);

  final ScrollController scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();

  final TextEditingController nikController = TextEditingController();
  final TextEditingController seafererCodeController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getCurrentProfile();
  }

  // @override
  // void onClose() {
  //   nikController.dispose();
  //   seafererCodeController.dispose();
  //   fullNameController.dispose();
  //   genderController.dispose();
  //   nationalityController.dispose();
  //   emailController.dispose();
  //   tempatLahirController.dispose();
  //   tanggalLahirController.dispose();
  //   oldPasswordController.dispose();
  //   newPasswordController.dispose();
  //   confirmNewPasswordController.dispose();
  //   scrollController.dispose();
  //   super.onClose();
  // }

  Future<void> getCurrentProfile() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? uc = prefs.getString('userUc');
    if (uc == null) {
      errorMessage.value = "Profile Tidak Dapat Ditemukan";
    } else {
      userData.value = await UserRepository.getLocalUser(uc: uc);
      _setUserData();
    }
    isLoading.value = false;
  }

  void _setUserData() {
    emailController.text = userData['data']?['email']?.toString() ?? "-";
    fullNameController.text = userData['data']?['full_name']?.toString() ?? "-";
    nikController.text = userData['data']?['nik']?.toString() ?? "-";
    seafererCodeController.text =
        userData['data']?['seafarer_code']?.toString() ?? "-";
    genderController.text =
        (userData['data']?['gender'] == 0) ? "Male" : "Female";
    nationalityController.text =
        userData['data']['citizenship'] == 1 ? "WNI" : "WNA";
    tempatLahirController.text = (userData['data']['born_place'] == null ||
            userData['data']['born_place'] == "")
        ? "-"
        : userData['data']['born_place'];
    var bornDate = userData['data']['born_date'];
    DateTime? signOnDate;
    if (bornDate != null && bornDate != "0000-00-00") {
      try {
        signOnDate = DateTime.parse(bornDate);
      } catch (e) {
        print('Error parsing tanggal lahir: $e');
      }
    }
    tanggalLahirController.text =
        (signOnDate == null) ? "-" : DateFormat.yMMMMd().format(signOnDate);
    activeFotoProfile.value = userData['data']?['foto']?.toString() ??
        "assets/pub/images/profile.jpg";
  }

  Future<void> updateProfile() async {
    isLoading.value = true; // Tampilkan loading indikator
    EasyLoading.show(status: 'Memperbarui profil...');

    final prefs = await SharedPreferences.getInstance();
    String? uc = prefs.getString('userUc');

    if (uc == null) {
      errorMessage.value = "Profile Tidak Dapat Ditemukan";
      EasyLoading.showError("Profile Tidak Dapat Ditemukan");
    } else {
      File? imageFile = image.value != null ? File(image.value!.path) : null;

      Map res = await profileRepository.updateUser(
        email: emailController.text,
        foto: imageFile,
        password: oldPasswordController.text,
        newpassword: newPasswordController.text,
      );

      if (res['status'] == true) {
        userData.value = await UserRepository.getLocalUser(uc: uc);
        _setUserData();
        isEditing.value = true;

        EasyLoading.showSuccess("Profil berhasil diperbarui");
        Get.offAndToNamed(Routes.INDEX); // Arahkan ke halaman index jika sukses
      } else {
        errorMessage.value = res['message'];
        EasyLoading.showError(res['message']); // Tampilkan pesan error
      }
    }

    isLoading.value = false;
    EasyLoading.dismiss(); // Tutup loading indikator
  }

  Future<void> editProfile() async {
    bool conStatus = await ConnectionTest.check();
    if (!conStatus) {
      Get.snackbar("Error", "Internet Connection Required to Update Profile",
          snackPosition: SnackPosition.BOTTOM);
    } else {
      isEditing.value = true;
    }
  }

  void toggleEditing() {
    isEditing.value = !isEditing.value;
  }

  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      fotoProfile.value = pickedFile;
      activeFotoProfile.value = pickedFile.path;
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

  bool canPop() {
    if (isEditing.value) {
      isEditing.value = false; // Batalkan edit mode jika ada
      return false; // Blok pop saat sedang edit
    }
    return true; // Izinkan pop saat tidak edit
  }
}
