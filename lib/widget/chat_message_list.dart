import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../states/message_state.dart';
import 'message_item.dart';

class ChatMessageList extends HookConsumerWidget {
  const ChatMessageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(activeSessionMessagesProvider);
    final scrollController = useScrollController();

    ref.listen(activeSessionMessagesProvider, (previous, next) {
      Future.delayed(const Duration(microseconds: 50), () {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    });

    return ListView.separated(
      controller: scrollController,
      itemBuilder: (context, index) {
        return MessageItem(message: messages[index]);
      },
      separatorBuilder: (context, index) => const Divider(
        height: 16,
      ),
      itemCount: messages.length,
    );
  }
}
