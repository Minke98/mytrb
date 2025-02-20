import 'package:get/get.dart';
import 'package:mytrb/app/Repository/faq_repository.dart';

class FaqController extends GetxController {
  final FaqRepository faqRepository;

  var faqs = <Map>[].obs;
  var isLoading = false.obs;

  FaqController({required this.faqRepository});

  @override
  void onInit() {
    super.onInit();
    fetchFaqs();
  }

  Future<void> fetchFaqs() async {
    isLoading.value = true;
    Map findFaq = await faqRepository.getFaq();
    if (findFaq['status'] == true) {
      faqs.assignAll(List<Map>.from(findFaq['faq']));
    }
    isLoading.value = false;
  }
}
