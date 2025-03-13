import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:mytrb/app/modules/chat_message/controllers/chat_message_controller.dart';
import 'package:mytrb/app/modules/chat_message/views/chat_bubble_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatMessageView extends GetView<ChatMessageController> {
  const ChatMessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title.value),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SmartRefresher(
              enablePullUp: false,
              onRefresh: () => controller.refreshController.refreshCompleted(),
              controller: controller.refreshController,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() => ListView.builder(
                      controller: controller.scrollController,
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) => buildChatItem(index),
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      controller: controller.chatTextInput,
                      maxLines: null,
                      style: TextStyle(
                          fontSize: 16, color: Get.theme.colorScheme.onSurface),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        hintText: "Ketik pesan...",
                        hintStyle: TextStyle(
                            color: Get.theme.colorScheme.onSurfaceVariant),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    controller.sendMessage();
                    controller.messages[9999999999999999] = {
                      "ago": "",
                      "message": controller.chatTextInput.text,
                      "isMe": true,
                    };
                    controller.chatTextInput.text = "";
                    await Future.delayed(const Duration(milliseconds: 500));
                    controller.scrollController.jumpTo(
                        controller.scrollController.position.maxScrollExtent);
                    controller.startTimer();
                    controller.initialize();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(1),
                    backgroundColor: Get.theme.colorScheme.primary,
                    minimumSize: const Size(50, 50),
                  ),
                  child: Transform.rotate(
                    angle: -45 * math.pi / 180,
                    child: Icon(
                      size: 28,
                      Icons.send,
                      color: Get.theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildChatItem(int index) {
    var key =
        int.tryParse(controller.messages.keys.elementAt(index).toString()) ?? 0;
    if (!controller.messages.containsKey(key)) {
      return const SizedBox(); // Hindari error dengan mengembalikan widget kosong
    }

    Map data = controller.messages[key] ?? {};
    bool showGroup = false;
    String ago = "";

    if (data.containsKey("ago")) {
      ago = "loading";
      showGroup = false;
    } else {
      DateTime parsed = DateTime.parse(data['date'] + " " + data['time'] + 'Z');
      ago = controller.convertToAgo(parsed);
      showGroup = controller.lastDate != data['date'];
      controller.lastDate.value = data['date'];
    }

    if (controller.lastName == data['sender']) {
      data['usename'] = false;
    } else {
      controller.lastName = data['sender'];
      data['usename'] = true;
    }

    Alignment algn =
        data['isMe'] == true ? Alignment.centerRight : Alignment.centerLeft;
    Color background = data['isMe'] == true
        ? Get.theme.colorScheme.primary
        : Get.theme.colorScheme.primaryContainer;
    Color textColor = data['isMe'] == true
        ? Get.theme.colorScheme.onPrimary
        : Get.theme.colorScheme.onPrimaryContainer;

    return Column(
      children: [
        if (showGroup) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(controller.convertToAgoDay(
                  DateTime.parse(data['date'] + " 00:00:00Z"))),
            ),
          ),
          const SizedBox(height: 10),
        ],
        ChatBubble(
            algn: algn,
            data: data,
            dataKey: key,
            ago: ago,
            background: background,
            textColor: textColor),
      ],
    );
  }
}
