import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../properties/presentation/providers/property_providers.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoriteIdsProvider);
    final allProperties = ref.watch(propertiesProvider).properties;
    final favorites = allProperties
        .where((p) => favoriteIds.contains(p.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favorites.isEmpty
          ? const EmptyState(
              icon: HugeIcons.strokeRoundedFavourite,
              title: 'No favorites yet',
              message: 'Tap the heart on a property to save it here.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: favorites.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final property = favorites[index];
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                    onTap: () => context.push(
                      '${RouteNames.propertyDetails}/${property.id}',
                    ),
                    child: ListTile(
                      title: Text(property.title),
                      subtitle: Text(property.locationLabel),
                      trailing: IconButton(
                        icon: const AppIcon(
                          HugeIcons.strokeRoundedFavourite,
                          color: Colors.red,
                        ),
                        onPressed: () => ref
                            .read(favoriteIdsProvider.notifier)
                            .toggle(property.id),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
