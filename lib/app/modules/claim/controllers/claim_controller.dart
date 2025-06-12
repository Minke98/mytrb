import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:mytrb/utils/dialog.dart';
import 'package:mytrb/utils/get_device_id.dart';

class ClaimController extends GetxController with GetTickerProviderStateMixin {
  final UserRepository userRepository;

  var isLoading = false.obs;
  var isSuccess = false.obs;
  var errorMessage = ''.obs;
  var passwordVisible = false.obs;
  var retypePasswordVisible = false.obs;
  var isChecking = false.obs;
  var isError = false.obs;
  var seafarerAvailable = false.obs;
  var nama = ''.obs;
  var nik = ''.obs;
  var ucParticipant = ''.obs;
  TextEditingController seafarerController = TextEditingController();
  late AnimationController animasiControl;
  late Animation<Offset> animation;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();

  ClaimController({required this.userRepository});

  @override
  void onInit() {
    super.onInit();
    // animasiControl = AnimationController(
    //   vsync: this, // Pastikan GetTickerProviderStateMixin digunakan
    //   duration: const Duration(milliseconds: 500),
    // );

    // animation = Tween<Offset>(
    //   begin: const Offset(0.0, 0.5),
    //   end: Offset.zero,
    // ).animate(CurvedAnimation(
    //   parent: animasiControl,
    //   curve: Curves.easeInOut,
    // ));
  }

  Future<void> claim() async {
    var deviceId = await getUniqueDeviceId();

    EasyLoading.show(status: 'Processing...');
    isLoading.value = true;

    var res = await userRepository.claim(
      device_id: deviceId,
      email: emailController.text,
      full_name: nama.value,
      password: passwordController.text,
      uc_participant: ucParticipant.value,
      username: usernameController.text,
    );

    EasyLoading.dismiss();
    isLoading.value = false;

    if (res['status'] == true) {
      onClaimSuccess();
    } else {
      errorMessage.value = res['message'];
      MyDialog.showErrorSnackbarRegist(
          res['message']); // Tampilkan error di snackbar
    }
  }

  Future<void> checkSeafarer() async {
    isChecking.value = true;
    isError.value = false;
    errorMessage.value = "";
    try {
      var res =
          await userRepository.checkSeafarer(seafarer: seafarerController.text);
      if (res['status'] == false) {
        isError.value = true;
        errorMessage.value = res['message'];
        seafarerAvailable.value =
            false; // Pastikan tidak muncul form saat gagal
      } else {
        var participant = res['data'];
        nama.value = participant["full_name"];
        nik.value = participant["nik"];
        ucParticipant.value = participant['uc_participant'];
        seafarerAvailable.value = true; // Perbaikan dari == ke =
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
      seafarerAvailable.value = false; // Pastikan tidak muncul form saat error
    } finally {
      isChecking.value = false;
    }
  }

  void resetClaim() {
    isSuccess.value = false;
    errorMessage.value = '';
    animasiControl.reset(); // Reset animasi saat reset klaim
  }

  void onClaimSuccess() {
    EasyLoading.dismiss();

    Get.snackbar(
      "Claim Successful",
      "Please login",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue.shade900,
      colorText: Colors.white,
    );

    Future.delayed(const Duration(seconds: 2), () {
      Get.offNamed(Routes.LOGIN);
    });
  }

  @override
  void onClose() {
    animasiControl.dispose();
    super.onClose();
  }
}
