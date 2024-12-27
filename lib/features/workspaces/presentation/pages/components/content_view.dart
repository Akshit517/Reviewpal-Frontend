import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/enums.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/channel_entity.dart';
import '../../../domain/entities/workspace_entity.dart';
import '../screens/assignment_screen.dart';
import '../screens/doubt_screen.dart';

class ContentView extends StatelessWidget {
  const ContentView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = GoRouterState.of(context).extra as Map<String, dynamic>?;
    
    if (args == null) {
      return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Select a channel to start chatting',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    final workspace = args['workspace'] as Workspace?;
    final category = args['category'] as Category?;
    final channel = args['channel'] as Channel?;
    final channelType = args['type'] as DisplayScreen?;

    if (workspace == null || category == null || channel == null) {
      return const Center(
        key: ValueKey('invalid-content'),
        child: Text('Invalid Screen')
      );
    }

    switch (channelType) {
      case DisplayScreen.assignment:
        return AssignmentScreen(
          workspace: workspace,
          category: category,
          channel: channel,
        );
      case DisplayScreen.doubts:
        return DoubtScreen(
          workspace: workspace,
          category: category,
          channel: channel,
        );
      default:
        return const Center(
          child: Text('Select a channel type')
        );
    }
  }
}