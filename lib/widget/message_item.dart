import 'package:chart_demo/models/message.dart';
import 'package:chart_demo/widget/message_content.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({super.key, required this.message});
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: message.isUser ? Colors.blue : Colors.grey,
          child: Text(message.isUser ? 'A' : 'GPT'),
        ),
        const SizedBox(
          width: 8,
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(
              right: 48,
            ),
            child: MessageContent(
              message: message,
            ),
          ),
        ),
      ],
    );
  }
}
