import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_error.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/property.dart';
import '../providers/property_providers.dart';
import '../widgets/property_card.dart';

class PropertiesScreen extends ConsumerStatefulWidget {
  const PropertiesScreen({super.key});

  @override
  ConsumerState<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends ConsumerState<PropertiesScreen> {
  String? _region;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(propertiesProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _applyFilters() async {
    await ref
        .read(propertiesProvider.notifier)
        .load(region: _region, type: PropertyType.residential);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(propertiesProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        actions: [
          IconButton(
            icon: const AppIcon(HugeIcons.strokeRoundedSearch01),
            onPressed: () => context.push(RouteNames.search),
          ),
          IconButton(
            icon: const AppIcon(HugeIcons.strokeRoundedFavourite),
            onPressed: () => context.push(RouteNames.favorites),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              0,
            ),
            child: TextField(
              controller: _searchController,
              onSubmitted: (value) =>
                  ref.read(propertiesProvider.notifier).search(value),
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: AppIcon(
                  HugeIcons.strokeRoundedSearch01,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                isDense: true,
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              itemCount: AppConstants.regions.length + 1,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final label = index == 0
                    ? l10n.allRegions
                    : AppConstants.regions[index - 1];
                final selected = index == 0
                    ? _region == null
                    : _region == AppConstants.regions[index - 1];
                return ChoiceChip(
                  label: Text(label),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      _region = index == 0
                          ? null
                          : AppConstants.regions[index - 1];
                    });
                    _applyFilters();
                  },
                );
              },
            ),
          ),
          Expanded(child: _buildBody(state)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.search),
        icon: const AppIcon(HugeIcons.strokeRoundedSearch01),
        label: Text(l10n.search),
      ),
    );
  }

  Widget _buildBody(PropertiesState state) {
    if (state.isLoading && state.properties.isEmpty) {
      return const AppLoader();
    }
    if (state.failure != null && state.properties.isEmpty) {
      return AppError(
        message: state.failure!.message,
        onRetry: () => ref
            .read(propertiesProvider.notifier)
            .load(region: _region, type: PropertyType.residential),
      );
    }
    if (state.isEmpty) {
      final l10n = AppLocalizations.of(context);
      return EmptyState(
        icon: HugeIcons.strokeRoundedRealEstate01,
        title: l10n.noProperties,
        message: l10n.adjustFilters,
      );
    }
    return RefreshIndicator(
      onRefresh: () =>
          ref.read(propertiesProvider.notifier).load(region: _region),
      child: GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.sm,
          crossAxisSpacing: AppSpacing.sm,
          childAspectRatio: 0.62,
        ),
        itemCount: state.properties.length,
        itemBuilder: (context, index) =>
            PropertyCard(property: state.properties[index]),
      ),
    );
  }
}
