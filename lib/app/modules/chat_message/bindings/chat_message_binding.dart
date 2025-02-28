import 'package:get/get.dart';
import 'package:mytrb/app/modules/chat_message/controllers/chat_message_controller.dart';

class ChatMessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatMessageController>(
        () => ChatMessageController(chatRepository: Get.find()));
  }
}
