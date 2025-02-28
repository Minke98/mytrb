import 'package:get/get.dart';
import 'package:mytrb/app/modules/chat/controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(
        () => ChatController(chatRepository: Get.find()));
  }
}
