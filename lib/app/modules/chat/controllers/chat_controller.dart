import 'package:get/get.dart';
import 'package:mytrb/app/Repository/chat_repository.dart';

class ChatController extends GetxController {
  final ChatRepository chatRepository;

  var isLoading = false.obs;
  var conversations = [].obs;

  ChatController({required this.chatRepository});

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> initializeConversations({bool showLoading = false}) async {
    isLoading.value = showLoading;

    var conversationSearch = await chatRepository.getConversations();

    if (conversationSearch['status'] == true) {
      conversations.value = conversationSearch['conversations'];
    }

    isLoading.value = false;
  }
}
