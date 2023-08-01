import 'package:chart_demo/models/session.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../injection.dart';
import '../models/message.dart';
import '../states/chat_ui_state.dart';
import '../states/message_state.dart';
import '../states/session_state.dart';

class UserInput extends HookConsumerWidget {
  const UserInput({super.key});

  Message _createMessage(
    String content, {
    String? id,
    bool? isUser = true,
    int? sessionId,
  }) {
    return Message(
      id: id ?? uuid.v4(),
      content: content,
      isUser: isUser ?? true,
      timestamp: DateTime.now(),
      sessionId: sessionId ?? 0,
    );
  }

  _sendMessage(
    WidgetRef ref,
    TextEditingController controller,
  ) async {
    final content = controller.text;
    Message message = _createMessage(content);

    var active = ref.watch(activeSessionProvider);
    var sessionId = active?.id ?? 0;
    if (sessionId <= 0) {
      active = Session(title: content);
      active = await ref
          .read(sessionStateNotifierProvider.notifier)
          .upsertSession(active);

      sessionId = active.id!;
      ref
          .read(sessionStateNotifierProvider.notifier)
          .setActiveSession(active.copyWith(id: sessionId));
    }
    ref
        .read(messageProvider.notifier)
        .upsertMessage(message.copyWith(sessionId: sessionId));
    controller.clear();
    _requestChatGPT(ref, content, sessionId: sessionId);
  }

  _requestChatGPT(
    WidgetRef ref,
    String content, {
    int? sessionId,
  }) async {
    ref.read(chatUiProvider.notifier).setRequestLoading(true);
    try {
      final id = uuid.v4();
      await chatgpt.streamChat(
        content,
        onSuccess: (text) {
          final message = _createMessage(
            content,
            id: id,
            sessionId: sessionId,
            isUser: false,
          );
          ref.read(messageProvider.notifier).upsertMessage(message);
        },
      );
    } catch (err) {
      logger.e("requestChatGPT error: $err", err);
    } finally {
      ref.read(chatUiProvider.notifier).setRequestLoading(false);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatUIState = ref.watch(chatUiProvider);
    final textController = TextEditingController();

    return TextField(
      enabled: !chatUIState.requestLoading,
      controller: textController,
      onSubmitted: (value) {
        if (textController.text.isNotEmpty) {
          _sendMessage(ref, textController);
        }
      },
      decoration: InputDecoration(
        hintText: 'Type a message',
        suffixIcon: IconButton(
          onPressed: () {
            if (textController.text.isNotEmpty) {
              _sendMessage(ref, textController);
            }
          },
          icon: const Icon(
            Icons.send,
          ),
        ),
      ),
    );
  }
}
