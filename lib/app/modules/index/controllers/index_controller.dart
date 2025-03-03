import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/Repository/news_repository.dart';
import 'package:mytrb/app/Repository/repository.dart';
import 'package:mytrb/app/Repository/sign_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexController extends GetxController {
  final SignRepository signRepository;
  IndexController({required this.signRepository});

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
}
