import 'package:chart_demo/models/session.dart';
import 'package:chart_demo/states/session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatHistoryScreen extends HookConsumerWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat History"),
      ),
      body: Center(
        child: state.when(
          data: (state) {
            return ListView(
              children: [
                for (var session in state.sessionList)
                  ChatHistoryItemWidget(session: session),
              ],
            );
          },
          error: (error, stack) => Text("$error"),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class ChatHistoryItemWidget extends HookConsumerWidget {
  final Session session;

  const ChatHistoryItemWidget({required this.session, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionStateNotifierProvider).valueOrNull;
    final editMode = useState(false);
    final controller = useTextEditingController();
    controller.text = session.title;
    return ListTile(
      title: editMode.value
          ? Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    final text = controller.text;
                    if (text.trim().isNotEmpty) {
                      ref
                          .read(sessionStateNotifierProvider.notifier)
                          .upsertSession(
                            session.copyWith(
                              title: text.trim(),
                            ),
                          );
                      editMode.value = false;
                    }
                  },
                ),
                IconButton(
                  onPressed: () {
                    editMode.value = false;
                  },
                  icon: const Icon(Icons.cancel),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Text(session.title),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    editMode.value = true;
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteConfirm(context, ref, session);
                  },
                ),
              ],
            ),
      onTap: () {
        ref
            .read(sessionStateNotifierProvider.notifier)
            .setActiveSession(session);
      },
      selected: state?.activeSession?.id == session.id,
    );
  }
}

Future _deleteConfirm(
    BuildContext context, WidgetRef ref, Session session) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete'),
        content: const Text('Are you sure to delete?'),
        actions: [
          TextButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(sessionStateNotifierProvider.notifier)
                  .deleteSession(session);
              GoRouter.of(context).pop();
            },
            child: const Text('Delete'),
          )
        ],
      );
    },
  );
}
