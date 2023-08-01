import 'package:go_router/go_router.dart';

import '../screen/chart_screen.dart';
import '../screen/chat_history_screen.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const ChartScreen(),
  ),
  GoRoute(
    path: '/history',
    builder: (context, state) => const ChatHistoryScreen(),
  ),
]);
