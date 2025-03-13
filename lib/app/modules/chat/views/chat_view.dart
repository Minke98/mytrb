import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/chat/controllers/chat_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => controller.conversations.isEmpty
            ? const Center(child: Text("No Conversations Available"))
            : ListView.builder(
                itemCount: controller.conversations.length,
                itemBuilder: (context, index) {
                  final conversation = controller.conversations[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Card(
                      color: Colors.blue.shade900,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(Routes.CHAT_MESSAGE, arguments: {
                            "pageName": "chat",
                            "roomName": conversation['room_name'],
                            "roomUc": conversation['uc_room'],
                            "toUc": conversation['uc_chat_user'],
                            "roomType": conversation['room_status']
                          });
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                maxRadius: 25,
                                child: Text(
                                  conversation['room_name_short'] ?? "",
                                  style: TextStyle(color: Colors.blue.shade900),
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      conversation['room_name'] ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white),
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Divider(height: 8),
                                    conversation['room_type'] == null
                                        ? const SizedBox.shrink()
                                        : Text(
                                            conversation['room_type'],
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )),
      ),
    );
  }
}
