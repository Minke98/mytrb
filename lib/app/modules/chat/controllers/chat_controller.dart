import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/Repository/chat_repository.dart';

class ChatController extends GetxController {
  final ChatRepository chatRepository;
  var conversations = [].obs;

  ChatController({required this.chatRepository});

  @override
  void onInit() {
    initializeConversations();
    super.onInit();
  }

  Future<void> initializeConversations() async {
    EasyLoading.show(status: "Loading...");

    var conversationSearch = await chatRepository.getConversations();

    if (conversationSearch['status'] == true) {
      conversations.value = conversationSearch['conversations'];
    }

    EasyLoading.dismiss();
  }
}
