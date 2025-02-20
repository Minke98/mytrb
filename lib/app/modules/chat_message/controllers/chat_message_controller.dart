import 'dart:developer';
import 'package:get/get.dart';
import 'package:mytrb/app/Repository/chat_repository.dart';

class ChatMessageController extends GetxController {
  final ChatRepository chatRepository;

  var messages = {}.obs;
  var room = ''.obs;
  var isLoading = false.obs;

  ChatMessageController({required this.chatRepository});

  Future<void> initialize(String ucRoom) async {
    isLoading.value = true;
    var res = await chatRepository.loadMessages(ucRoom: ucRoom);
    if (res['status'] == true) {
      log("== chat phase 4 from init ${res['messages']}");
      messages.value = res['messages'];
      room.value = ucRoom;
    }
    isLoading.value = false;
  }

  void setReady(Map newMessages, String ucRoom) {
    log("== chat phase 5 from setReady $newMessages");
    messages.value = newMessages;
    room.value = ucRoom;
  }

  Future<void> sendMessage(String message, {String? ucRoom, String? to}) async {
    isLoading.value = true;
    var res = await chatRepository.saveBeforeSend(
        ucRoom: ucRoom, ucTo: to, message: message);
    if (res['status'] == true) {
      messages[res['room']] = res['message'];
    }
    isLoading.value = false;
  }

  Future<void> getNewMessages(String last, String ucRoom) async {
    var res = await chatRepository.loadNewMessage(last: last, room: ucRoom);
    if (res['new_messages'] != null && res['new_messages'].isNotEmpty) {
      messages.addAll(res['new_messages']);
    }
  }

  Future<void> setStatus(
      List<String> messageIds, int status, String ucRoom) async {
    var res = await chatRepository.updateStatus(
        status: status, messagesId: messageIds, room: ucRoom);
    if (res['status'] == true && res.containsKey('updated')) {
      messages.addAll(res['updated']);
    }
  }

  Future<void> getStatus(String ucRoom) async {
    var res = await chatRepository.loadUpdatedMessage(room: ucRoom);
    if (res.containsKey("updatedMessage")) {
      messages.addAll(res['updatedMessage']);
    }

    if (messages.isNotEmpty) {
      int lastKey = messages.keys.last;
      Map msg = messages[lastKey];
      String last = msg['date'] + " " + msg['time'];
      var res2 = await chatRepository.loadNewMessage(last: last, room: ucRoom);
      log("== chat phase 6 check for new messages $res2");
      if (res2.containsKey('new_messages')) {
        messages.addAll(res2['new_messages']);
      }
    }
  }
}
