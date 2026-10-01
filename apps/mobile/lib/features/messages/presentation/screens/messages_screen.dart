import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/widgets/empty_state.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: const EmptyState(
        icon: HugeIcons.strokeRoundedMessage01,
        title: 'No conversations',
        message: 'Messages with landlords will appear here.',
      ),
    );
  }
}
