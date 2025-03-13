import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mytrb/app/Repository/chat_repository.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatMessageController extends GetxController {
  final ChatRepository chatRepository;

  var messages = {}.obs;
  var room = ''.obs;
  var isLoading = false.obs;
  final ScrollController scrollController = ScrollController();
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  final TextEditingController chatTextInput = TextEditingController();
  final FocusNode chatFocusNode = FocusNode();

  var title = ''.obs;
  var ucTo = ''.obs;
  var ucRoom = ''.obs;
  var roomType = 1.obs;
  var firstSet = false.obs;
  var firstLoad = true.obs;
  var sOffset = 0.0.obs;

  // RxMap<int, Map> messages = <int, Map>{}.obs;
  var lastDate = "".obs;
  String? lastName;
  Timer? timer;

  ChatMessageController({required this.chatRepository});

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      title.value = args['roomName'] ?? "";
      ucTo.value = args['toUc'] ?? "";
      ucRoom.value = args['roomUc'] ?? "";
      roomType.value = args['roomType'] ?? 1;
    } else {
      log("WARNING: Get.arguments is null!");
    }
    initialize();
  }

  Future<void> initialize() async {
    isLoading.value = true;
    var res = await chatRepository.loadMessages(ucRoom: ucRoom.value);
    if (res['status'] == true) {
      log("== chat phase 4 from init ${res['messages']}");
      messages.value = res['messages'];
      room.value = ucRoom.value;
    }
    isLoading.value = false;
  }

  void setReady(Map newMessages, String ucRoom) {
    log("== chat phase 5 from setReady $newMessages");
    messages.value = newMessages;
    room.value = ucRoom;
  }

  Future<void> sendMessage() async {
    isLoading.value = true;
    var res = await chatRepository.saveBeforeSend(
        ucRoom: ucRoom.value, ucTo: ucTo.value, message: chatTextInput.text);
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

  String convertToAgo(DateTime input) {
    DateTime linput = input.toLocal();
    Duration diff = DateTime.now().difference(linput);
    if (diff.inDays > 3) {
      // var format = DateFormat.yMMMMd().addPattern("H:m:s");
      var format = DateFormat.jm();
      return format.format(linput);
    } else if (diff.inDays >= 1) {
      var format = DateFormat.jm();
      return format.format(linput);
      // return '${diff.inDays} hari yang lalu';
    } else if (diff.inHours >= 1) {
      // return '${diff.inHours} jam yang lalu';
      var format = DateFormat.jm();
      return format.format(linput);
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} menit yang lalu';
    } else if (diff.inSeconds >= 1) {
      // return '${diff.inSeconds} beberapa saat yang lalu';
      return 'beberapa saat yang lalu';
    } else {
      return 'baru saja';
    }
  }

  String convertToAgoDay(DateTime input) {
    DateTime linput = input.toLocal();
    Duration diff = DateTime.now().difference(linput);

    // .addPattern("H:m");
    if (diff.inDays > 7) {
      var format = DateFormat.yMMMMd();
      return format.format(linput);
    } else if (diff.inDays >= 2) {
      var format = DateFormat('EEEE');
      return format.format(linput);
    } else if (diff.inDays >= 1) {
      // var format = DateFormat('EEEE');
      // return format.format(input);
      // return '${diff.inDays} hari yang lalu';
      return "Kemarin";
    } else {
      return 'Hari Ini';
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(onScrollEvent);
    chatTextInput.dispose();
    cancelTimer();
    super.onClose();
  }

  void onScrollEvent() {
    double extentAfter = scrollController.position.extentAfter;
    sOffset.value = extentAfter;
  }

  void startTimer() {
    cancelTimer();
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {});
  }

  void cancelTimer() {
    timer?.cancel();
    timer = null;
  }
}
