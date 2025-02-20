import 'package:get/get.dart';
import 'package:mytrb/app/Repository/chat_repository.dart';
import 'package:mytrb/app/modules/chat_message/controllers/chat_message_controller.dart';

class ChatMessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatRepository>(() => ChatRepository(), fenix: true);

    Get.lazyPut<ChatMessageController>(() =>
        ChatMessageController(chatRepository: Get.find<ChatRepository>()));
  }
}
