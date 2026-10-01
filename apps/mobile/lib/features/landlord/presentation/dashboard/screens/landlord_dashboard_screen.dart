import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../app/router/route_names.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../core/widgets/app_icon.dart';
import '../../../../../core/widgets/empty_state.dart';
import '../../../../properties/presentation/providers/property_providers.dart';

class LandlordDashboardScreen extends ConsumerWidget {
  const LandlordDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final properties = ref.watch(propertiesProvider).properties;

    return Scaffold(
      appBar: AppBar(title: const Text('Landlord Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: HugeIcons.strokeRoundedRealEstate01,
                  label: 'Listings',
                  value: '${properties.length}',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _StatCard(
                  icon: HugeIcons.strokeRoundedMessage01,
                  label: 'Inquiries',
                  value: '0',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: HugeIcons.strokeRoundedView,
                  label: 'Views',
                  value: '0',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _StatCard(
                  icon: HugeIcons.strokeRoundedBookmark01,
                  label: 'Favorites',
                  value: '0',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Properties',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () => context.push(RouteNames.addProperty),
                child: const Text('Add new'),
              ),
            ],
          ),
          if (properties.isEmpty)
            const EmptyState(
              icon: HugeIcons.strokeRoundedRealEstate01,
              title: 'No listings yet',
              message: 'Add your first property to start receiving inquiries.',
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: properties.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final property = properties[index];
                return Card(
                  child: ListTile(
                    title: Text(property.title),
                    subtitle: Text(property.locationLabel),
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
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.addProperty),
        icon: const AppIcon(HugeIcons.strokeRoundedAdd01),
        label: const Text('Add Property'),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final HugeIconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppIcon(icon, color: theme.colorScheme.primary),
            const SizedBox(height: AppSpacing.sm),
            Text(value, style: theme.textTheme.headlineMedium),
            Text(label, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
