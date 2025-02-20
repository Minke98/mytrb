import 'package:get/get.dart';
import 'package:mytrb/app/Repository/chat_repository.dart';
import 'package:mytrb/app/modules/chat/controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatRepository>(() => ChatRepository(), fenix: true);
    Get.lazyPut<ChatController>(
        () => ChatController(chatRepository: Get.find<ChatRepository>()));
  }
}
