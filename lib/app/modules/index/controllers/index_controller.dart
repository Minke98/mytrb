import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/Repository/news_repository.dart';
import 'package:mytrb/app/Repository/repository.dart';
import 'package:mytrb/app/Repository/sign_repository.dart';
import 'package:mytrb/app/Repository/sync_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/utils/auth_biometric.dart';
import 'package:mytrb/utils/connection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class IndexController extends GetxController {
  final SignRepository signRepository;
  final SyncRepository syncRepository;
  IndexController({required this.signRepository, required this.syncRepository});

  var isLoading = false.obs;
  var signStatus = false.obs;
  var signUc = ''.obs;
  var fotoProfile = ''.obs;
  var isNeedSync = false.obs;
  var news = <Map>[].obs;
  var rowInWrap = 1.obs;
  var menuGridCount = 1.obs;
  var scale = 1.obs;
  var lastWidth = 1.obs;
  var activeProfileFoto = ''.obs;
  var currentIndex = 0.obs;
  final CarouselController carouselController = CarouselController();
  var syncStatus = ''.obs;
  var isSyncing = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeHome();
  }

  void changeCurrentIndex(int index) {
    currentIndex.value = index;
  }

  Future<void> initializeHome() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String techUser = prefs.getString("userUc") ?? '';

    var user = await UserRepository.getLocalUser(uc: techUser);
    if (user['status'] == true) {
      user = user['data'];
      if (user['foto'] != null) {
        prefs.setString("foto_profile", user['foto']);
        fotoProfile.value = user['foto'];
      }
    }

    var getSignStatus =
        await signRepository.getStatus(seafarerCode: user["seafarer_code"]);
    bool needSync = await Repository.isNeedSync();
    // List<Map<String, dynamic>> getNews = await NewsRepository.getNewNews();
    List<Map> getNews =
        await NewsRepository.getNews(itemCount: 5, characterMax: 120);

    signStatus.value = getSignStatus['status'];
    signUc.value = getSignStatus["sign_uc"];
    isNeedSync.value = needSync;
    news.assignAll(getNews); // Tidak akan error lagi
    isLoading.value = false;
  }

  Future<void> reInitializeHome() async {
    await initializeHome();
  }

  Future<void> startSyncing() async {
    bool isAuthenticated = await BiometricAuth.authenticateUser(
        'Use biometric authentication to syncing');
    if (!isAuthenticated) {
      EasyLoading.showError('Autentikasi biometrik gagal');
      return;
    }
    bool isConnected = await ConnectionUtils.checkInternetConnection();
    if (!isConnected) {
      ConnectionUtils.showNoInternetDialog(
        "Apologies, the syncing process requires an internet connection.",
      );
      return;
    }

    EasyLoading.show(status: 'Please wait...');
    bool isFastConnection = await ConnectionUtils.isConnectionFast();
    if (!isFastConnection) {
      ConnectionUtils.showNoInternetDialog(
        "Apologies, the syncing process requires a stable internet connection.",
        isSlowConnection: true,
      );
      return;
    }
    isSyncing.value = true;

    // Menampilkan loading indicator
    EasyLoading.show(status: "Syncing...");

    Map syncRes = await syncRepository.doSync();

    EasyLoading.dismiss(); // Menutup loading setelah proses selesai

    if (syncRes['status'] == false) {
      syncStatus.value = syncRes['message'];

      // Menampilkan toast error
      EasyLoading.showError(syncRes['message']);
    } else {
      syncStatus.value = "Sync Completed";

      // Menampilkan toast sukses
      EasyLoading.showSuccess("Sync Completed");
      isNeedSync.value = false;

      // Tunggu sebentar sebelum navigasi ulang ke home
      // Future.delayed(const Duration(seconds: 1), () {
      //   Get.offNamed(Routes.INDEX);
      // });
    }

    isSyncing.value = false;
  }

  void openWhatsAppGroup() async {
    const String groupUrl = "https://chat.whatsapp.com/HVgP8i0EH1BBuZYtKVZElA";
    final Uri uri = Uri.parse(groupUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Tidak dapat membuka WhatsApp");
    }
  }
}
