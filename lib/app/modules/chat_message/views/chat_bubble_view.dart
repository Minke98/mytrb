import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/chat_message/controllers/chat_message_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBubble extends GetView<ChatMessageController> {
  final Alignment algn;
  final Map data;
  final String ago;
  final Color background;
  final Color textColor;
  final int dataKey;

  const ChatBubble({
    super.key,
    required this.algn,
    required this.data,
    required this.ago,
    required this.background,
    required this.textColor,
    required this.dataKey,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: algn,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          data['isMe'] == true
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ago == 'loading'
                      ? SizedBox(
                          width: 15,
                          height: 15,
                          child: Transform.scale(
                            scale: 0.5,
                            child: const CircularProgressIndicator(),
                          ),
                        )
                      : Obx(() {
                          int status =
                              controller.messages[dataKey]?['status'] ?? 0;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                ago,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              _buildStatusIcon(status, context),
                            ],
                          );
                        }),
                )
              : const SizedBox.shrink(),
          Flexible(
            child: Card(
              margin: EdgeInsets.only(
                  left: 8.0,
                  bottom: data['usename'] == false ? 0 : 10.0,
                  right: 8.0,
                  top: 10.0),
              color: background,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  data['usename'] == false || data['name'] == null
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, bottom: 2.0, right: 8.0, top: 8.0),
                          child: Text(
                            data['name'],
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: textColor,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectableText(
                      data['message'],
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: textColor),
                      onTap: () => _onMessageTap(data['message']),
                    ),
                  ),
                ],
              ),
            ),
          ),
          data['isMe'] == false
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ago == 'loading'
                      ? const CircularProgressIndicator()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ago,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(int status, BuildContext context) {
    switch (status) {
      case 1:
        return Icon(Icons.done,
            color: Theme.of(context).colorScheme.outline, size: 15);
      case 2:
        return Icon(Icons.done_all,
            color: Theme.of(context).colorScheme.outline, size: 15);
      case 3:
        return Icon(Icons.done_all,
            color: Theme.of(context).colorScheme.primary, size: 15);
      default:
        return Icon(Icons.timer_sharp,
            color: Theme.of(context).colorScheme.primary, size: 15);
    }
  }

  void _onMessageTap(String message) {
    RegExp regExp = RegExp(r"\b(?:https?://|www\.)\S+\b",
        caseSensitive: false, multiLine: true);
    Iterable<RegExpMatch> matches = regExp.allMatches(message);
    if (matches.isNotEmpty) {
      String url = matches.first.group(0)!;
      launchURL(url);
    }
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
