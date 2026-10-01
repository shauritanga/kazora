import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/widgets/empty_state.dart';

class InquiriesScreen extends StatelessWidget {
  const InquiriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inquiries')),
      body: const EmptyState(
        icon: HugeIcons.strokeRoundedBubbleChat,
        title: 'No inquiries',
        message: 'Interested renters will appear here.',
      ),
    );
  }
}
