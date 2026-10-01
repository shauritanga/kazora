import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../core/widgets/app_icon.dart';
import '../../../../../core/widgets/empty_state.dart';
import '../../../../properties/presentation/providers/property_providers.dart';

class LandlordPropertiesScreen extends ConsumerWidget {
  const LandlordPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final properties = ref.watch(propertiesProvider).properties;

    return Scaffold(
      appBar: AppBar(title: const Text('My Properties')),
      body: properties.isEmpty
          ? const EmptyState(
              icon: HugeIcons.strokeRoundedRealEstate01,
              title: 'No listings',
              message: 'Add a property to get started.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: properties.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final property = properties[index];
                return Card(
                  child: ListTile(
                    title: Text(property.title),
                    subtitle: Text(property.locationLabel),
                    isThreeLine: false,
                    trailing: IconButton(
                      icon: const AppIcon(HugeIcons.strokeRoundedEdit01),
                      onPressed: () => context.push(
                        '${RouteNames.editProperty}/${property.id}',
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.addProperty),
        icon: const AppIcon(HugeIcons.strokeRoundedAdd01),
        label: const Text('Add Property'),
      ),
    );
  }
}
