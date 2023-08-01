import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatUiState {
  final bool requestLoading;

  ChatUiState({
    this.requestLoading = false,
  });
}

class ChatUiStateProvider extends StateNotifier<ChatUiState> {
  ChatUiStateProvider() : super(ChatUiState());

  void setRequestLoading(bool value) {
    state = ChatUiState(requestLoading: value);
  }
}

final chatUiProvider = StateNotifierProvider<ChatUiStateProvider, ChatUiState>(
    (ref) => ChatUiStateProvider());
