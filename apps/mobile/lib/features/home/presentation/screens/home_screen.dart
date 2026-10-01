import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_error.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../properties/presentation/providers/property_providers.dart';
import '../../../properties/presentation/widgets/property_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(propertiesProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(propertiesProvider);
    final phone = ref.watch(sessionProvider).user?.phone;
    final featured = state.properties
        .where((p) => p.isFeatured || p.isVerified)
        .take(6)
        .toList();
    final latest = state.properties.take(6).toList();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(propertiesProvider.notifier).load(),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.homeGreeting,
                          style: theme.textTheme.headlineSmall,
                        ),
                        if (phone != null && phone.isNotEmpty)
                          Text(
                            phone,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const AppIcon(
                      HugeIcons.strokeRoundedNotification01,
                    ),
                    onPressed: () => context.push(RouteNames.notifications),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(
                      AppSpacing.radiusMedium,
                    ),
                  ),
                  child: AppIcon(
                    HugeIcons.strokeRoundedSearch01,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                title: Text(l10n.homeSearchTitle),
                subtitle: Text(l10n.homeSearchSubtitle),
                onTap: () => context.push(RouteNames.search),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (state.isLoading && state.properties.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: Center(child: AppLoader()),
                )
              else if (state.failure != null && state.properties.isEmpty)
                AppError(
                  message: state.failure!.message,
                  onRetry: () =>
                      ref.read(propertiesProvider.notifier).load(),
                )
              else if (state.properties.isEmpty)
                EmptyState(
                  icon: HugeIcons.strokeRoundedRealEstate01,
                  title: l10n.noProperties,
                  message: l10n.adjustFilters,
                )
              else ...[
                _SectionHeader(
                  title: l10n.featured,
                  actionLabel: l10n.seeAll,
                  onAction: () => context.push(RouteNames.properties),
                ),
                if (featured.isEmpty)
                  SizedBox(
                    height: 160,
                    child: Center(
                      child: Text(
                        l10n.noFeatured,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: 252,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: featured.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: AppSpacing.sm),
                      itemBuilder: (context, index) => SizedBox(
                        width: 180,
                        child: PropertyCard(property: featured[index]),
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),
                _SectionHeader(
                  title: l10n.latest,
                  actionLabel: l10n.seeAll,
                  onAction: () => context.push(RouteNames.properties),
                ),
                ...latest.map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: PropertyCard(property: p),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        TextButton(onPressed: onAction, child: Text(actionLabel)),
      ],
    );
  }
}
