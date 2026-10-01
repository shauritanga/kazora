import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/widgets/empty_state.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookings')),
      body: const EmptyState(
        icon: HugeIcons.strokeRoundedCalendar01,
        title: 'No bookings',
        message: 'Your property viewings and bookings will appear here.',
      ),
    );
  }
}
