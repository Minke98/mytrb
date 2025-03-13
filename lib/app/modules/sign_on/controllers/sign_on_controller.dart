import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mytrb/app/Repository/instructor_repository.dart';
import 'package:mytrb/app/Repository/sign_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/app/data/models/instructor.dart';
import 'package:mytrb/app/data/models/type_vessel.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:mytrb/utils/auth_biometric.dart';
import 'package:mytrb/utils/connection.dart';
import 'package:mytrb/utils/dialog.dart';
import 'package:mytrb/utils/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class SignController extends GetxController {
  final SignRepository signRepository;

  SignController({required this.signRepository});
  final IndexController indexController = Get.put(
      IndexController(signRepository: Get.find(), syncRepository: Get.find()));
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<TypeVessel> vesselList = <TypeVessel>[].obs;
  TextEditingController dateController = TextEditingController();
  TextEditingController dosenController = TextEditingController();
  DateTime? signOnDate;
  final selectedDate = Rxn<DateTime>();
  var dosenList = <Instructor>[].obs;
  final dosenSelected = Rxn<Instructor>();
  final selectedVessel = Rxn<TypeVessel>();
  final TextEditingController namaKapalController = TextEditingController();
  final TextEditingController namaPerusahaanController =
      TextEditingController();
  final TextEditingController imoNumberController = TextEditingController();
  final TextEditingController mmsiNumberController = TextEditingController();
  final Rx<XFile?> signOnFoto = Rx<XFile?>(null);
  final Rx<XFile?> mutasiOnFoto = Rx<XFile?>(null);
  final Rx<XFile?> imoFoto = Rx<XFile?>(null);
  final Rx<XFile?> crewListFoto = Rx<XFile?>(null);
  final Rx<XFile?> bukuPelautFoto = Rx<XFile?>(null);
  var signOnError = ''.obs;
  var mutasiOnError = ''.obs;
  var imoFotoError = ''.obs;
  var crewListFotoError = ''.obs;
  var bukuPelautFotoError = ''.obs;
  var isSubmitting = false.obs;
  var isDropdownOpened = false.obs;
  final Rx<Size?> imageSize = Rx<Size?>(null);

  @override
  Future<void> onInit() async {
    super.onInit();
    await prepareSignForm();
    loadDosenList();
  }

  void pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().toUtc(),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade900, // Warna header dan tombol OK
              onPrimary: Colors.white, // Warna teks pada tombol OK
              surface: Colors.white, // Warna background dialog
              onSurface: Colors.black, // Warna teks di dalam dialog
            ),
            dialogBackgroundColor: Colors.white, // Warna background dialog
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    Colors.blue.shade900, // Warna tombol BATAL & OK
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      selectedDate.value = pickedDate;
      dateController.text = DateFormat.yMMMMd().format(pickedDate);
    }
  }

  Future<void> prepareSignForm() async {
    isLoading.value = true;
    try {
      Map vessel = await signRepository.getVesselType();

      if (vessel['status'] == true && vessel['vessel'] != null) {
        vesselList.assignAll(vessel['vessel'] as List<TypeVessel>);
      } else {
        errorMessage.value = 'Data kapal tidak ditemukan';
      }
    } catch (e) {
      errorMessage.value = 'Gagal mengambil data kapal';
      print("Error prepareSignForm: $e"); // Debugging
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitSignForm() async {
    isSubmitting.value = true;
    EasyLoading.show(status: 'Please wait...');

    try {
      bool isAuthenticated = await BiometricAuth.authenticateUser(
          'Use biometric authentication to login');
      if (!isAuthenticated) {
        EasyLoading.showError('Autentikasi biometrik gagal');
        return;
      }

      bool isConnected = await ConnectionUtils.checkInternetConnection();
      if (!isConnected) {
        EasyLoading.dismiss();
        ConnectionUtils.showNoInternetDialog(
          "Apologies, the login process requires an internet connection.",
        );
        return;
      }

      bool isFastConnection = await ConnectionUtils.isConnectionFast();
      if (!isFastConnection) {
        EasyLoading.dismiss();
        ConnectionUtils.showNoInternetDialog(
          "Apologies, the login process requires a stable internet connection.",
          isSlowConnection: true,
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      var user =
          await UserRepository.getLocalUser(uc: prefs.getString("userUc"));
      if (user['status'] != true) throw "User tidak ditemukan";
      var userData = user['data'];

      String signOnDbFormat = DateFormat('yyyy-MM-dd').format(DateTime.now());
      Map getPos = await Location.getLocation();
      if (getPos['status'] == false) {
        EasyLoading.dismiss();
        if (Get.context != null) {
          MyDialog.showError(Get.context!, getPos['message']);
        }
        return;
      }
      Position pos = getPos['position'];

      bool res = await signRepository.doSignOn(
        signOnDate: signOnDbFormat,
        seafarerCode: userData['seafarer_code'],
        ucTypeVessel: selectedVessel.value?.uc ?? '',
        vesselName: namaKapalController.text,
        companyName: namaPerusahaanController.text,
        imoNumber: imoNumberController.text,
        mmsiNumber: mmsiNumberController.text,
        ucLecturer: dosenSelected.value?.uc ?? '',
        signOnLat: pos.latitude,
        signOnLon: pos.longitude,
        mutasiOnFoto:
            mutasiOnFoto.value != null ? File(mutasiOnFoto.value!.path) : null,
        signOnFoto:
            signOnFoto.value != null ? File(signOnFoto.value!.path) : null,
        imoFoto: imoFoto.value != null ? File(imoFoto.value!.path) : null,
        crewListFoto:
            crewListFoto.value != null ? File(crewListFoto.value!.path) : null,
        bukuPelautFoto: bukuPelautFoto.value != null
            ? File(bukuPelautFoto.value!.path)
            : null,
      );

      if (!res) throw "Gagal melakukan sign";

      EasyLoading.dismiss();
      await Get.offAllNamed(Routes.INDEX);
    } catch (e) {
      errorMessage.value = e.toString();
      EasyLoading.showError(errorMessage.value);
    } finally {
      EasyLoading.dismiss();
      isSubmitting.value = false; // Reset setelah selesai
    }
  }

  Future<void> loadDosenList() async {
    Map response = await InstructorRepository.findInstructor(
        patern: "", type: InstructorRepository.DOSEN);
    if (response['status'] == true) {
      dosenList.assignAll(response['data']);
    }
  }

  bool isFormValid() {
    return selectedDate.value != null &&
        dosenSelected.value != null &&
        selectedVessel.value != null &&
        namaKapalController.text.isNotEmpty &&
        namaPerusahaanController.text.isNotEmpty &&
        imoNumberController.text.isNotEmpty &&
        mmsiNumberController.text.isNotEmpty &&
        signOnFoto.value != null &&
        mutasiOnFoto.value != null &&
        imoFoto.value != null &&
        crewListFoto.value != null &&
        bukuPelautFoto.value != null;
  }
}
