import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../properties/domain/entities/property.dart';
import '../../../properties/presentation/providers/property_providers.dart';
import '../../../properties/presentation/widgets/property_card.dart';

class _PriceBand {
  const _PriceBand(this.min, this.max);
  final int? min;
  final int? max;
}

const _priceBands = [
  _PriceBand(null, null),
  _PriceBand(null, 200000),
  _PriceBand(200000, 500000),
  _PriceBand(500000, 1000000),
  _PriceBand(1000000, null),
];

class _Category {
  const _Category(this.icon, this.label, this.value);

  final HugeIconData icon;
  final String label;
  final String? value;
}

class _FilterSelection {
  _FilterSelection({this.region, this.type, this.priceBand = 0});

  String? region;
  PropertyType? type;
  int priceBand;

  int get activeCount =>
      (region != null ? 1 : 0) +
      (type != null ? 1 : 0) +
      (priceBand != 0 ? 1 : 0);
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _speech = SpeechToText();
  final _filters = _FilterSelection();
  String? _category;
  bool _listening = false;
  int _sort = 0;
  List<String> _recents = const [];

  @override
  void initState() {
    super.initState();
    _recents = LocalStorage.instance.recentSearches;
    _controller.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(propertiesProvider).properties.isEmpty) {
        _runSearch(saveRecent: false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _speech.cancel();
    super.dispose();
  }

  Future<void> _runSearch({bool saveRecent = true}) async {
    final q = _controller.text.trim();
    final band = _priceBands[_filters.priceBand];
    await ref
        .read(propertiesProvider.notifier)
        .search(
          q,
          region: _filters.region,
          type: _filters.type,
          category: _category,
          priceMin: band.min,
          priceMax: band.max,
        );
    if (saveRecent && q.isNotEmpty) {
      await LocalStorage.instance.saveRecentSearch(q);
      if (mounted) {
        setState(() => _recents = LocalStorage.instance.recentSearches);
      }
    }
  }

  Future<void> _selectCategory(String? value) async {
    setState(() => _category = value);
    await _runSearch(saveRecent: false);
  }

  Future<void> _reset() async {
    setState(() {
      _controller.clear();
      _category = null;
      _filters.region = null;
      _filters.type = null;
      _filters.priceBand = 0;
      _sort = 0;
    });
    await ref.read(propertiesProvider.notifier).resetSearch();
    if (mounted) await _runSearch(saveRecent: false);
  }

  Future<void> _openFilters() async {
    final result = await showModalBottomSheet<_FilterSelection>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _FilterSheet(initial: _filters),
    );
    if (result == null || !mounted) return;
    setState(() {
      _filters.region = result.region;
      _filters.type = result.type;
      _filters.priceBand = result.priceBand;
    });
    await _runSearch(saveRecent: false);
  }

  Future<void> _toggleVoice() async {
    if (_listening) {
      await _speech.stop();
      if (mounted) setState(() => _listening = false);
      return;
    }
    final available = await _speech.initialize();
    if (!available || !mounted) {
      if (mounted && !available) {
        context.showSnackBar(
          AppLocalizations.of(context).voiceDenied,
          isError: true,
        );
      }
      return;
    }
    setState(() => _listening = true);
    await _speech.listen(
      onResult: (result) {
        _controller.text = result.recognizedWords;
        if (result.finalResult && mounted) {
          setState(() => _listening = false);
          _runSearch();
        }
      },
    );
  }

  List<Property> _sorted(List<Property> input) {
    final list = [...input];
    switch (_sort) {
      case 1:
        list.sort((a, b) => a.priceTzs.compareTo(b.priceTzs));
      case 2:
        list.sort((a, b) => b.priceTzs.compareTo(a.priceTzs));
      default:
        list.sort((a, b) {
          final ac = a.createdAt;
          final bc = b.createdAt;
          if (ac == null || bc == null) return 0;
          return bc.compareTo(ac);
        });
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(propertiesProvider);

    final categories = [
      _Category(HugeIcons.strokeRoundedGrid, l10n.catAll, null),
      _Category(HugeIcons.strokeRoundedBed, l10n.catRoom, 'room'),
      _Category(
        HugeIcons.strokeRoundedApartment,
        l10n.catApartment,
        'apartment',
      ),
      _Category(HugeIcons.strokeRoundedHouse02, l10n.catHouse, 'house'),
      _Category(
        HugeIcons.strokeRoundedBuilding02,
        l10n.catOffice,
        'office',
      ),
      _Category(HugeIcons.strokeRoundedShopSign, l10n.catShop, 'shop'),
    ];
    final filterCount =
        _filters.activeCount + (_category != null ? 1 : 0);
    final showRecents =
        _controller.text.trim().isEmpty && _recents.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.search)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xs,
              AppSpacing.md,
              0,
            ),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _runSearch(),
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 12,
                ),
                prefixIcon: AppIcon(
                  HugeIcons.strokeRoundedSearch01,
                  size: 20,
                  strokeWidth: 2.2,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_controller.text.isNotEmpty)
                      IconButton(
                        icon: AppIcon(
                          HugeIcons.strokeRoundedCancelCircle,
                          size: 20,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          _controller.clear();
                          _runSearch(saveRecent: false);
                        },
                      ),
                    IconButton(
                      icon: AppIcon(
                        HugeIcons.strokeRoundedMic01,
                        size: 20,
                        color: _listening
                            ? AppColors.error
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      onPressed: _toggleVoice,
                    ),
                    IconButton(
                      tooltip: l10n.filters,
                      icon: filterCount == 0
                          ? AppIcon(
                              HugeIcons.strokeRoundedSlidersHorizontal,
                              size: 20,
                              color: theme.colorScheme.onSurfaceVariant,
                            )
                          : Badge(
                              label: Text('$filterCount'),
                              child: AppIcon(
                                HugeIcons.strokeRoundedSlidersHorizontal,
                                size: 20,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                      onPressed: _openFilters,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_listening)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                l10n.voiceListening,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              itemCount: categories.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, i) {
                final category = categories[i];
                final selected = _category == category.value;
                return InkWell(
                  borderRadius: BorderRadius.circular(
                    AppSpacing.radiusMedium,
                  ),
                  onTap: () => _selectCategory(category.value),
                  child: Container(
                    width: 76,
                    decoration: BoxDecoration(
                      color: selected
                          ? theme.colorScheme.primary.withValues(alpha: 0.12)
                          : theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusMedium,
                      ),
                      border: Border.all(
                        color: selected
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppIcon(
                          category.icon,
                          color: selected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          category.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: selected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (showRecents)
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                ),
                itemCount: _recents.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, i) {
                  return ActionChip(
                    avatar: const AppIcon(
                      HugeIcons.strokeRoundedClock01,
                      size: 16,
                    ),
                    label: Text(_recents[i]),
                    onPressed: () {
                      _controller.text = _recents[i];
                      _runSearch();
                    },
                  );
                },
              ),
            ),
          Expanded(child: _buildResults(state)),
        ],
      ),
    );
  }

  Widget _buildResults(PropertiesState state) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    if (state.isLoading && state.properties.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Center(child: AppLoader()),
      );
    }
    if (state.failure != null && state.properties.isEmpty) {
      return AppError(
        message: state.failure!.message,
        onRetry: () => _runSearch(saveRecent: false),
      );
    }
    if (state.properties.isEmpty) {
      return EmptyState(
        icon: HugeIcons.strokeRoundedSearchRemove,
        title: l10n.noResults,
        message: l10n.differentTerm,
        actionLabel: l10n.reset,
        onAction: _reset,
      );
    }
    final results = _sorted(state.properties);
    final sortLabels = [l10n.sortNewest, l10n.sortPriceAsc, l10n.sortPriceDesc];
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.resultsCount(results.length),
              style: theme.textTheme.titleMedium,
            ),
            PopupMenuButton<int>(
              icon: const AppIcon(HugeIcons.strokeRoundedSorting01),
              initialValue: _sort,
              onSelected: (i) => setState(() => _sort = i),
              itemBuilder: (context) => List.generate(
                sortLabels.length,
                (i) => PopupMenuItem(value: i, child: Text(sortLabels[i])),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final property in results)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: PropertyCard(property: property),
          ),
      ],
    );
  }
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.initial});

  final _FilterSelection initial;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late final _FilterSelection _draft = _FilterSelection(
    region: widget.initial.region,
    type: widget.initial.type,
    priceBand: widget.initial.priceBand,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final priceLabels = [
      l10n.priceAny,
      l10n.priceUnder200k,
      l10n.price200to500k,
      l10n.price500kto1m,
      l10n.priceOver1m,
    ];
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.filters, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.regionFilter, style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                ChoiceChip(
                  label: Text(l10n.allRegions),
                  selected: _draft.region == null,
                  onSelected: (_) => setState(() => _draft.region = null),
                ),
                for (final region in AppConstants.regions)
                  ChoiceChip(
                    label: Text(region),
                    selected: _draft.region == region,
                    onSelected: (_) => setState(() => _draft.region = region),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.typeFilter, style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                ChoiceChip(
                  label: Text(l10n.typeAny),
                  selected: _draft.type == null,
                  onSelected: (_) => setState(() => _draft.type = null),
                ),
                ChoiceChip(
                  label: Text(l10n.typeResidential),
                  selected: _draft.type == PropertyType.residential,
                  onSelected: (_) =>
                      setState(() => _draft.type = PropertyType.residential),
                ),
                ChoiceChip(
                  label: Text(l10n.typeCommercial),
                  selected: _draft.type == PropertyType.commercial,
                  onSelected: (_) =>
                      setState(() => _draft.type = PropertyType.commercial),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.priceFilter, style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: List.generate(priceLabels.length, (i) {
                return ChoiceChip(
                  label: Text(priceLabels[i]),
                  selected: _draft.priceBand == i,
                  onSelected: (_) => setState(() => _draft.priceBand = i),
                );
              }),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: l10n.apply,
              onPressed: () => Navigator.of(context).pop(_draft),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
